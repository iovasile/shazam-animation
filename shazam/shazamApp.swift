//
//  shazamApp.swift
//  shazam
//
//  Created by Ionut Vasile on 03.06.2023.
//

import SwiftUI

@main
struct shazamApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
	@State private var breathing = false
	@State var random1: CGFloat = 0.7
	@State var random2: CGFloat = 0.7
	
	
	@State var timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
	
	func startTimer() {
		timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
	}
	
	var body: some View {
		
		ZStack {
			
			Circle()
				.fill(RadialGradient(gradient: Gradient(colors: [.gray.opacity(0.1), Color.white.opacity(0.01)]), center: .center, startRadius: 0, endRadius: 400))
				.frame(width: random2*420, height: random2*500)
			
			Circle()
				.fill(RadialGradient(gradient: Gradient(colors: [.gray.opacity(0.1), Color.white.opacity(0.01)]), center: .center, startRadius: 0, endRadius: 400))
				.frame(width: random1*360, height: random1*400)
			
			
			Circle()
				.fill(RadialGradient(gradient: Gradient(colors: [.gray.opacity(0.1), Color.white.opacity(0.01)]), center: .center, startRadius: 150, endRadius: 190))
				.frame(width: random2*300, height: 200)
			
			CircleAndLinks()
				.frame(width: 200, height: 200)
				.scaleEffect(breathing ? random1 : 1)
				
		}
		.onAppear {
			Timer.scheduledTimer (withTimeInterval: 0.5, repeats: false) { _ in
				withAnimation(.easeInOut(duration: 0.5)
					.repeatForever(autoreverses: true)) {
						breathing = true
					}
			}
		}
		.onReceive(timer) { _ in
			withAnimation(.linear(duration: 0.5)) {
				random1 = CGFloat.random(in: 0.7...1.4)
				random2 = CGFloat.random(in: 0.7...1.4)
			}
		}
	}
}

struct CircleAndLinks: View {
	@State private var animated = false
	
	var body: some View {
		ZStack {
			Circle()
				.fill(
					LinearGradient(gradient: Gradient(colors: [Color(white: 0.3), Color(white: 0.35)]), startPoint: .top, endPoint: .bottom)
				)
				.shadow(color: .gray, radius: 0.2, y: -1.5)
			
			let fromTrim: CGFloat = 0.43
			let toTrim: CGFloat = 1
			
			let whiteLink = Link(fromTrim: animated ? fromTrim : fromTrim - 2, toTrim: animated ? toTrim : toTrim - 2, color: .white)
			let blackLink = Link(fromTrim: animated ? fromTrim + 1.25 : fromTrim, toTrim: toTrim, color: .black)
			
			Group {
				whiteLink
				whiteLink
					.rotationEffect(.degrees(180))
			}
			.shadow(color: .black, radius: 0.2, y: 4)
			
			Group {
				blackLink
				blackLink
					.rotationEffect(.degrees(180))
			}
			.shadow(color: .white, radius: 0.2, y: 4 )
		}
		.onAppear {
			withAnimation(.easeIn(duration: 0.8)) {
				self.animated = true
			}
		}
	}
}

struct Link: View {
	let fromTrim: CGFloat
	let toTrim: CGFloat
	let color: Color
	
	var body: some View {
		ShazamCapsule()
			.rotation(.degrees(-45))
			.offset(x: -7, y: -16)
			.trim(from: fromTrim, to: toTrim)
			.stroke(color, style: .init(lineWidth: 20, lineCap: .round))
			.frame(width: 90, height: 64)
	}
}

struct ShazamCapsule: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		
		let radius = rect.height / 2 // Calculate the radius as half the height of the rect
		
		let bottom = CGPoint(x: rect.midX, y: rect.maxY) // Bottom center point of the capsule
		let trailing = CGPoint(x: rect.maxX, y: rect.midY) // Right middle point of the capsule
		let leading = CGPoint(x: rect.minX, y: rect.midY) // Left middle point of the capsule
		
		path.move(to: bottom) // Move to the bottom center point of the capsule
		
		// Add the right arc from the trailing point
		path.addRelativeArc(center: CGPoint(x: trailing.x - radius, y: trailing.y), radius: radius, startAngle: .degrees(90), delta: .degrees(-180))
		
		// Add the left arc from the leading point
		path.addRelativeArc(center: CGPoint(x: leading.x + radius, y: leading.y), radius: radius, startAngle: .degrees(-90), delta: .degrees(-180))
		
		path.closeSubpath() // Close the path to form a closed shape
		
		return path
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}
