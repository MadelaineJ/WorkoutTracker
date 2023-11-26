import SwiftUI

struct SimpleInputModalView: View {
    @Binding var inputText: String
    @Binding var isNameNotUnique: Bool
    var onSubmit: () -> Void
    var isNameValid: () -> Bool = { true }
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            if isNameNotUnique {
                Text("Template names must be unique")
                    .foregroundColor(.red)
                    .padding()
            }
            
            FirstResponderTextField(text: $inputText, placeholder: "Enter Name", onCommit: {
                if !inputText.isEmpty && isNameValid() {
                    self.onSubmit()
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.bottom, 0)

            Button(action: {
                if !inputText.isEmpty && isNameValid() {
                    onSubmit()
                    self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Submit")
            }
            .disabled(inputText.isEmpty)
            .padding()


        }
        .onAppear() {
            self.inputText = ""
            isNameNotUnique = false  // Reset the flag
        }
    }
}


struct SimpleInputModalView_Previews: PreviewProvider {
    @State static private var previewText: String = ""
    @State static private var isNameNotUnique: Bool = false

    static var previews: some View {
        SimpleInputModalView(inputText: $previewText, isNameNotUnique: $isNameNotUnique, onSubmit: {
            print("Submit action from preview")
        }, isNameValid: { true })  // You might also need to add isNameValid closure here
    }
}

