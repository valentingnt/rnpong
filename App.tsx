import React, { useMemo } from 'react';
import { View, Dimensions } from 'react-native';
import { Gesture, GestureDetector, GestureHandlerRootView } from 'react-native-gesture-handler';
import Animated, { runOnJS, useAnimatedStyle, useSharedValue, withSpring } from 'react-native-reanimated';
import { NativeModules } from 'react-native';


const App = () => {
  const { width, height } = useMemo(() => Dimensions.get('screen'), [Dimensions])

  console.log('width', width)
  console.log('height', height)
  const x = useSharedValue(width / 2);
  const y = useSharedValue(height / 2);

  function sendHapticFeedback() {
    'runOnJS'

    NativeModules.CustomHapticsModule.CustomHapticsFunction(x.value / width, y.value / height)
  }

  const pan = Gesture.Pan().onBegin(() => {
    x.value = withSpring(width / 2)
    y.value = withSpring(height / 2)
  })
    .onChange((event) => {
      x.value = event.translationX + width / 2
      y.value = event.translationY + height / 2

      runOnJS(sendHapticFeedback)()
    }).onEnd(() => {
      x.value = withSpring(width / 2)
      y.value = withSpring(height / 2)

      runOnJS(sendHapticFeedback)()
    })

  const animatedStyle = useAnimatedStyle(() => ({
    transform: [
      { translateX: x.value - 50 },
      { translateY: y.value - 50 },
    ],
  }))

  return (
    <GestureHandlerRootView>
      <GestureDetector gesture={pan}>
        <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
          <Animated.View style={[{
            position: 'absolute',
            top: 0,
            left: 0,
            width: 100,
            height: 100,
            borderRadius: 50,
            backgroundColor: 'red'
          }, animatedStyle]} />
        </View>
      </GestureDetector>
    </GestureHandlerRootView>
  );
};

export default App;