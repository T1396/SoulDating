//
//  OnboardingPictureView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 11.06.24.
//

import SwiftUI
import PhotosUI

struct OnboardingPictureView: View {
    // MARK: properties
    @ObservedObject var viewModel: OnboardingViewModel
    @Binding var progress: Double
    @Binding var stepIndex: Int

    @State private var selectedPhotoItem: PhotosPickerItem?

    // MARK: computed properties
    var pickerLabelText: String {
        viewModel.imageData == nil ? "Choose picture" : "Update Picture"
    }

    // MARK: body
    var body: some View {
        VStack {
            VStack(spacing: 4) {
                Text(Strings.uploadPic)
                    .appFont(size: 32, textWeight: .bold)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(Strings.imageHelpText)
                    .appFont(size: 14, textWeight: .light)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 2)
            }
            .padding(.horizontal)


            GeometryReader { geometry in
                ZStack(alignment: .bottom) {

                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 2)
                        .foregroundStyle(.secondaryAccent)


                    if let imageData = viewModel.imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing, height: geometry.size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(2)
                    }

                    PhotosPicker(
                        selection: $selectedPhotoItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Label(pickerLabelText, systemImage: "photo.on.rectangle")
                            .labelStyle(.titleAndIcon)
                            .appButtonStyle()
                    }
                    .onChange(of: selectedPhotoItem) { _, newValue in
                        guard let newValue else { return }
                        Task {
                            if let data = try? await newValue.loadTransferable(type: Data.self) {
                                viewModel.imageData = data
                            }
                        }
                    }
                    .padding(.bottom)
                }
            }
            .padding(.horizontal)

            Spacer()

            Button(action: goToNextPage) {
                Text(Strings.continues)
                    .appButtonStyle(fullWidth: true)
            }
            .padding()
            .disabled(viewModel.imageData == nil)

        }
        .onAppear {
            withAnimation {
                progress = 0.6
            }
        }
    }


    // MARK: functions
    private func goToNextPage() {
        withAnimation {
            stepIndex += 1 // go to next onboarding page
        }
    }

}

#Preview {
    OnboardingPictureView(viewModel: OnboardingViewModel(), progress: .constant(0.6), stepIndex: .constant(5))
}
