//
//  PlayerViewController.swift
//  player
//
//  Created by 徐于茹 on 2023/7/24.
//

import UIKit

class PlayerViewController: UIViewController {
    // 歌曲相關資料
    let songName = ["Moral Of The Story", "I Love U & I Hate U", "Lavender Haze"]
    let albumsPic = ["MoralOfTheStory_1", "ILoveUIHateU_2", "LavenderHaze_3"]
    let singers = ["Ashe", "Gnash", "Taylor Swift"]
    
    // 顯示選項相關資料
    let showOption = ["album", "lyrics"]
    
    // 當前歌曲索引
    var currentIndex = 0
    
    // 是否顯示歌詞視圖
    var showingLyrics = false
    
    // IBOutlet連結
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var songSegmentedControl: UISegmentedControl!
    @IBOutlet weak var songPicImageView: UIImageView!
    @IBOutlet weak var lyricsScrollView: UIScrollView!
    @IBOutlet weak var lyricsLabel: UILabel!
    @IBOutlet weak var songPageControl: UIPageControl!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var preButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設定UIButton的配置
        var config = UIButton.Configuration.plain()
        // 設定圖像，將圖像顏色設定為白色並調整尺寸為64pt
        let resizedImage = UIImage(systemName: "arrowtriangle.right.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal).resized(to: CGSize(width: 64, height: 64))
        config.image = resizedImage
        
        // 將配置應用到按鈕
        playButton.configuration = config
        
        // pageControl的點點
        songPageControl.numberOfPages = songName.count
        
        // 歌詞scrollView先隱藏
        lyricsScrollView.isHidden = true
        showingLyrics = false
        
        // 動態設定 Label 大小
        lyricsLabel.sizeToFit()
        
        // 初始化畫面
        changeSong()
    }
    
    // 切換至專輯封面視圖
    func showSongPicView() {
        songPicImageView.isHidden = false
        lyricsScrollView.isHidden = true
        showingLyrics = false
    }
    
    // 切換至歌詞視圖
    func showLyricsView() {
        songPicImageView.isHidden = true
        lyricsScrollView.isHidden = false
        showingLyrics = true
    }
    
    // 上一首歌曲
    func preSong() {
        currentIndex = (currentIndex == 0) ? (songName.count - 1) : (currentIndex - 1)
        changeSong()
    }
    
    // 下一首歌曲
    func nextSong() {
        currentIndex = (currentIndex == songName.count - 1) ? 0 : (currentIndex + 1)
        changeSong()
    }
    
    // 更新歌曲資訊及視圖顯示
    func changeSong() {
        titleLabel.text = songName[currentIndex]
        singerLabel.text = singers[currentIndex]
        songPicImageView.image =  UIImage(named: albumsPic[currentIndex])
        songPageControl.currentPage = currentIndex
        lyricsLabel.text = "\(songName[currentIndex])歌詞"
        lyricsLabel.sizeToFit()
        songSegmentedControl.selectedSegmentIndex = 0
        
        // 根據showingLyrics的值，自動切換視圖
        showingLyrics = false
        if showingLyrics {
            showLyricsView()
        } else {
            showSongPicView()
        }
    }
    
    // 切換專輯封面視圖和歌詞視圖的IBAction
    @IBAction func changeShow(_ sender: Any) {
        switch songSegmentedControl.selectedSegmentIndex {
        case 0:
            showSongPicView()
        case 1:
            showLyricsView()
        default:
            break
        }
    }
    
    // 切換歌曲的IBAction
    @IBAction func changeSongPageControl(_ sender: Any) {
        currentIndex = songPageControl.currentPage
        changeSong()
    }
    
    // 滑動手勢事件
    @IBAction func onSwiper(_ sender: Any) {
        // 判斷滑動方向，並執行對應的上一首或下一首歌曲
        if let gestureRecognizer = sender as? UISwipeGestureRecognizer {
            if gestureRecognizer.direction == .left {
                nextSong()
            } else if gestureRecognizer.direction == .right {
                preSong()
            }
        }
    }
    
    // 上一首按鈕的IBAction
    @IBAction func pre(_ sender: Any) {
        preSong()
    }

    // 下一首按鈕的IBAction
    @IBAction func next(_ sender: Any) {
        nextSong()
    }
}

// Helper extension to resize UIImage
extension UIImage {
    // 定義一個方法 resized(to:)，用於調整圖片的大小
    func resized(to size: CGSize) -> UIImage? {
        // 使用 UIGraphicsImageRenderer 來處理圖片的繪製，設定繪製的尺寸為指定的 size
        let renderer = UIGraphicsImageRenderer(size: size)
        
        // 使用 renderer.image { _ in ... } 進行圖片的繪製
        return renderer.image { _ in
            // 在指定的繪製區域中，使用 draw(in:) 方法將原始圖片繪製到新的圖片中，同時調整尺寸
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
