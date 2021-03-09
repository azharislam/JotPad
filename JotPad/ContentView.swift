//
//  ContentView.swift
//  JotPad
//
//  Created by Azhar on 09/03/2021.
//

import SwiftUI
import PencilKit

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    
    @State var canvas = PKCanvasView()
    @State var isDraw = true
    @State var color: Color = .black
    @State var type: PKInkingTool.InkType = .pencil
    @State var colorPicker = false
    
    // default medium is Pen
    
    var body: some View {
        NavigationView{
            //Drawing view
            DrawingView(canvas: $canvas, isDraw: $isDraw, type: $type, color: $color)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: Button(action: {
                    saveImage()
                    
                }, label: {
                    Image("download")
                        .resizable()
                        .frame(width: 22, height: 22)
                }), trailing: HStack(spacing: 15){
                    
                    Button(action: {
                        isDraw = false
                    }) {
                        Image("eraser")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .font(.title)
                    }
                    
                    ColorPicker(
                        "",
                        selection: $color
                    ).frame(width: 22, height: 22)
                    .padding()
                    
                    Menu {
                        
                        Button(action: {
                            
                            // changing type
                            isDraw = true
                            type = .pencil
                        }) {
                            Label {
                                Text("Pencil")
                            } icon: {
                                Image(systemName: "pencil")
                            }
                        }
                        
                        Button(action: {
                            isDraw = true
                            type = .pen
                        }) {
                            Label {
                                Text("Pen")
                            } icon: {
                                Image(systemName: "pencil.tip")
                            }
                        }
                        
                        Button(action: {
                            isDraw = true
                            type = .marker
                        }) {
                            Label {
                                Text("Marker")
                            } icon: {
                                Image(systemName: "highlighter")
                            }
                        }
                        
                    } label: {
                        Image("menu")
                            .resizable()
                            .frame(width: 22, height: 22)
                    }
                    
                })
        }
    }
    
    func saveImage() {
        
        //getting image from canvas
        let image = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
        
        // saving to album
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

struct DrawingView: UIViewRepresentable {
    
    // to save the drawing into Photo album
    
    @Binding var canvas: PKCanvasView
    @Binding var isDraw: Bool
    @Binding var type: PKInkingTool.InkType
    @Binding var color: Color
    
    var ink: PKInkingTool{
        PKInkingTool(type, color: UIColor(color))
    }
    let eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.tool = isDraw ? ink : eraser
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
        // updating tool whenever main view updates
        uiView.tool = isDraw ? ink : eraser
    }
}
