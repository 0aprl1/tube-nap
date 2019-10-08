READ ME:

The app is fully functional. 
The app can be run either on Xcode, using the simulator, or on a real device supporting at least iOS 12.4 (so from the iPhone 5s onwards)


							RUN ON XCODE’S SIMULATOR
———————————————————————————————————————————————

If you choose to run the app on the simulator, the sound classification algorithm cannot be used because the app doesn’t have the required framework for audio processing on an Intel processor. For the rest the app works as usual.


								RUN ON REAL DEVICE
———————————————————————————————————————————————

If you want to test the app on a real device, please feel free to contact me and I will add your address to the list of verified devices. If instead you own a developer account, please run the app by accessing it.
Before launching the app you need to follow these steps:

	- uncomment line 40 in CurrentJourney.swift file
	- uncomment from line 346 to 355 in CurrentJourney.swift file
	- uncomment from line 401 to 520 in CurrentJourney.swift file

If you are experiencing issues with the libAudioProcessing please refer to this guide (Deployement to Core ML - Sound Classification)

	https://apple.github.io/turicreate/docs/userguide/sound_classifier/export-coreml.html
