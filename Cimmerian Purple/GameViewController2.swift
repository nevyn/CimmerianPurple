//
//  GameViewController2.swift
//  Cimmerian Purple
//
//  Created by Nevyn Bengtsson on 2015-01-24.
//  Copyright (c) 2015 Thirdcog. All rights reserved.
//

import Foundation

class GameViewController2 : GameViewController {
	var audio = PdAudioController()
	var file : PdFile?
	var displayLink : CADisplayLink?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		var status = audio.configurePlaybackWithSampleRate(44100, numberChannels: 2, inputEnabled: false, mixingEnabled: false);
		audio.active = true
		println("Audio status: \(status.value)");
		
		file = PdFile.openFileNamed("test.pd", path: NSBundle.mainBundle().resourcePath) as? PdFile
		println("File: \(file)")
		
		displayLink = CADisplayLink(target: self, selector: "update");
		displayLink!.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes);
	}
	
	override func rotateByHAngle(hAngle: Float, vAngle: Float) {
		super.rotateByHAngle(hAngle, vAngle: vAngle);
		PdBase.sendFloat(hAngle, toReceiver: "hAngleDelta");
	}
	
	func update()
	{
		var hAngle = heroNode.presentationNode().rotation.w * heroNode.presentationNode().rotation.y
		PdBase.sendFloat(hAngle, toReceiver: "hAngle");
		
        let translation = lookGesture.translationInView(self.view)
        //let hAngleDelta = acos(Float(translation.x) / 200) - Float(M_PI_2)
		let hAngleDelta = heroNode.physicsBody!.angularVelocity.x;
		PdBase.sendFloat(hAngleDelta, toReceiver: "hAngleDelta");

	}
}