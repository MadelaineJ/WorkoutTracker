import SwiftUI

struct SimpleInputModalView: View {
    @Binding var inputText: String
    var onSubmit: () -> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            // Submit button
            Button(action: {
                if !inputText.isEmpty {
                    onSubmit()
                    self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Submit")
            }
            .disabled(inputText.isEmpty)
            .padding()

            // Text field
            FirstResponderTextField(text: $inputText, placeholder: "Enter Exercise Name", onCommit: {
                if !inputText.isEmpty {
                    self.onSubmit()
                    self.presentationMode.wrappedValue.dismiss() // Dismiss the modal
                }
            })
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding()
        }
        .onAppear() {
            self.inputText = ""
        }
    }
}

struct SimpleInputModalView_Previews: PreviewProvider {
    @State static private var previewText: String = ""
    
    static var previews: some View {
        SimpleInputModalView(inputText: $previewText, onSubmit: {
            print("Submit action from preview")
        })
    }
}
