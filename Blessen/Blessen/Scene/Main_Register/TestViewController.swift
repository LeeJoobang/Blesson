//
//  TestViewController.swift
//  Blessen
//
//  Created by Jooyoung Lee on 2023/03/02.
//
//
//import UIKit
//import AVFoundation
//import CropViewController
//
//class ViewController: UIViewController {
//
//    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
//    var cropView = UIView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//
//        imageView.contentMode = .scaleAspectFit
//        imageView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
//        imageView.center = view.center
//        view.addSubview(imageView)
//
//        let cameraButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
//        cameraButton.setTitle("Camera", for: .normal)
//        cameraButton.backgroundColor = .red
//        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
//        cameraButton.center = CGPoint(x: view.center.x, y: imageView.frame.maxY + 100)
//        view.addSubview(cameraButton)
//
//        let albumButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
//        albumButton.setTitle("Album", for: .normal)
//        albumButton.backgroundColor = .red
//        albumButton.addTarget(self, action: #selector(albumButtonTapped), for: .touchUpInside)
//        albumButton.center = CGPoint(x: view.center.x, y: cameraButton.frame.maxY + 50)
//        view.addSubview(albumButton)
//    }
//
//    @IBAction func selectImageButtonTapped(_ sender: UIButton) {
//        showImagePicker()
//    }
//
//
//    @objc func cameraButtonTapped() {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = .camera
//        present(picker, animated: true, completion: nil)
//    }
//
//    @objc func albumButtonTapped() {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = .photoLibrary
//        present(picker, animated: true, completion: nil)
//    }
//
//}

// 이미지 선택 및 표시
//extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//    func showImagePicker(){
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//        present(imagePickerController, animated: true, completion: nil)
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
//            return
//        }
//        let cropViewController = CropViewController(croppingStyle: .circular, image: image)
//        cropViewController.delegate = self
//        present(cropViewController, animated: true, completion: nil)
//    }
//}
//
//
//// 이미지 자르기
//extension ViewController: CropViewControllerDelegate {
//    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
//        let circularImage = image.circularImage
//        imageView.image = circularImage
//        cropViewController.dismiss(animated: true, completion: nil)
//    }
//}
//
//// 자른 이미지 보여주기
//extension UIImage {
//    var circularImage: UIImage? {
//        let squareImage = fixOrientation().cropToSquare()
//        let imageSize = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
//        let renderer = UIGraphicsImageRenderer(size: imageSize)
//        return renderer.image { _ in
//            UIBezierPath(roundedRect: CGRect(origin: .zero, size: imageSize), cornerRadius: imageSize.width / 2).addClip()
//            squareImage.draw(in: CGRect(origin: CGPoint(x: (imageSize.width - squareImage.size.width) / 2, y: (imageSize.height - squareImage.size.height) / 2), size: squareImage.size))
//        }
//    }
//
//    func fixOrientation() -> UIImage {
//        if self.imageOrientation == UIImage.Orientation.up {
//            return self
//        }
//        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
//        self.draw(in: CGRect(origin: .zero, size: self.size))
//        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return normalizedImage ?? self
//    }
//
//    func cropToSquare() -> UIImage {
//        let originalWidth  = self.size.width
//        let originalHeight = self.size.height
//        let cropSquare = min(self.size.width, self.size.height)
//        let offsetX = (originalWidth - cropSquare) / 2.0
//        let offsetY = (originalHeight - cropSquare) / 2.0
//
//        let rect = CGRect(x: offsetX, y: offsetY, width: cropSquare, height: cropSquare)
//        let imageRef = self.cgImage!.cropping(to: rect)
//        let cropped = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
//        return cropped
//    }
//}
