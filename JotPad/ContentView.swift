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
    
    // default medium is Pen
    
    var body: some View {
        NavigationView{
            //Drawing view
            DrawingView(canvas: $canvas, isDraw: $isDraw)
                .navigationTitle("Jot")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: Button(action: {
                   
                    //saving image
                   
                }, label: {
                    Image(systemName: "square.and.arrow.down.fill")
                        .font(.title)
                }), trailing: HStack(spacing: 15){
                    
                    Button(action: {
                        
                        isDraw.toggle()
                    }) {
                        Image(systemName: "pencil.slash")
                            .font(.title)
                    }
                    
                    //Menu for ink type and color
                    Menu {
                        
                        ColorPicker(selection: $color) {
                            Label {
                                Text("Color")
                            } icon: {
                                Image(systemName: "eyedropper.full")
                            }
                        }
                        
                        Button(action: {
                            
                            // changing type
                            
                        }) {
                            Label {
                                Text("Pencil")
                            } icon: {
                                Image(systemName: "pencil")
                            }
                        }
                        
                        Button(action: {}) {
                            Label {
                                Text("Pen")
                            } icon: {
                                Image(systemName: "pencil.tip")
                            }
                        }
                        
                        Button(action: {}) {
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
}

struct DrawingView: UIViewRepresentable {
    
    // to save the drawing into Photo album
    
    @Binding var canvas: PKCanvasView
    @Binding var isDraw: Bool
    
    let ink = PKInkingTool(.pencil, color: .black)
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
