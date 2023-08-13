import UIKit
import AVFoundation
import OSLog

//struct Song {
//    let name: String
//    let albumPic: String
//    let songFile: String
//    let singer: String
//}

class PlayerViewController: UIViewController {
    let logger = Logger()

    var songs: [Song]!
    
    // 顯示選項相關資料
    let showOption: [(String, String)] = [("album", "專輯封面"), ("lyrics", "歌詞")]
    
    // 當前歌曲索引
    var currentIndex: Int!
    
    // 是否顯示歌詞視圖
    var showingLyrics = false
    
    var player = AVPlayer()
    
    var timeObserverToken: Any?
    
    var isRandom = false
    
    var isRepeat = false
    
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
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var songPassTimeLabel: UILabel!
    @IBOutlet weak var songDurationLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupSlider()
        lyricsScrollView.isHidden = true
        showingLyrics = false
        lyricsLabel.sizeToFit()
        changeSong()
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { _ in
            if self.isRepeat {
                self.repeatSong()
            } else if !self.isRandom {
                
                self.nextSong()
            } else {
                self.randomSong()
            }
            self.playSong()
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if player.timeControlStatus == .playing {
            removeTimeObserver()
            player.pause()
        }
    }
    
    func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            CGColor(srgbRed: 53/255, green: 91/255, blue: 98/255, alpha: 1),
            CGColor(srgbRed: 31/255, green: 49/255, blue: 57/255, alpha: 1)
        ]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupSlider() {
        let thumbImage = UIImage(systemName: "circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15))
        timeSlider.setThumbImage(thumbImage, for: .normal)
        timeSlider.tintColor = .white
    }
    
    // 顯示專輯封面視圖
    func showSongPicView() {
        songPicImageView.isHidden = false
        lyricsScrollView.isHidden = true
        showingLyrics = false
    }
    
    // 顯示歌詞視圖
    func showLyricsView() {
        songPicImageView.isHidden = true
        lyricsScrollView.isHidden = false
        showingLyrics = true
    }
    
    // 重複播放目前歌曲
    func repeatSong () {
        changeSong()
    }
    
    // 隨機播放下一首歌曲
    func randomSong() {
        var randomIndex: Int = currentIndex // 將 randomIndex 初始化為 currentIndex 的初始值
        repeat {
            randomIndex = Int.random(in: 0...songs.count-1)
        } while randomIndex == currentIndex
        logger.log("進入隨機 \(randomIndex)")
        removeTimeObserver()
        currentIndex = randomIndex
        changeSong()
    }
    
    // 切換到上一首歌曲
    func preSong() {
        currentIndex = (currentIndex == 0) ? (songs.count - 1) : (currentIndex - 1)
        // 移除前一首歌曲的時間觀察器
        removeTimeObserver()
        // 切換歌曲
        changeSong()
    }
    
    // 切換到下一首歌曲
    func nextSong() {
        if !isRandom {
            
            currentIndex = (currentIndex == songs.count - 1) ? 0 : (currentIndex + 1)
            removeTimeObserver()
            changeSong()
        } else {
            randomSong()
        }
    }
    
    // 格式化歌曲時間
    func formatTimeDuration(_ duration: CMTime?) -> String {
        guard let duration = duration else {
            return "00:00"
        }
        
        let totalSeconds = CMTimeGetSeconds(duration)
        let minutes = Int(totalSeconds / 60)
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        
        let formattedDuration = String(format: "%02d:%02d", minutes, seconds)
        return formattedDuration
    }
    
    // 設置歌曲播放時間的 UI 顯示
    func setTimeUI(passTime: String, durationTime: String) {
        songPassTimeLabel.text = passTime
        songDurationLabel.text = durationTime
    }
    
    // 設置歌曲播放進度條的 UI 顯示
    func setSliderUI(currentTime: Float, songDuration: Float) {
        timeSlider.value = currentTime
        timeSlider.minimumValue = 0
        timeSlider.maximumValue =  songDuration
    }
    
    // 移除歌曲播放時間觀察器
    func removeTimeObserver() {
        if let token = timeObserverToken {
            player.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    
    // 添加歌曲播放時間觀察器
    func addSongDuration() {
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let interval = CMTime(seconds: 1, preferredTimescale: timeScale)
        let mainQueue = DispatchQueue.main
        
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue) { [weak self] time in
            guard let self = self else { return } // 使用weak self避免retain cycle
            
            if self.player.timeControlStatus == .playing {
                // 取得歌曲總長度
                let songDuration = self.player.currentItem?.duration
                let formattedDuration = self.formatTimeDuration(songDuration)
                
                // 取得當前播放時間
                let currentTime = CMTimeGetSeconds(time)
                let formattedCurrentTime = self.formatTimeDuration(CMTime(seconds: currentTime, preferredTimescale: timeScale))
                
                // 更新播放時間的 UI 顯示
                self.setTimeUI(passTime: formattedCurrentTime, durationTime: formattedDuration)
                
                // 如果滑塊不在被拖動的狀態，則更新播放進度條的 UI 顯示
                if !self.timeSlider.isTracking {
                    self.setSliderUI(currentTime: Float(currentTime), songDuration: Float(songDuration?.seconds ?? 0))
                }
            }
        }
    }
    
    // 更新歌曲資訊及視圖顯示
    func changeSong() {
        let currentSong = songs[currentIndex]
        titleLabel.text = currentSong.name
        singerLabel.text = currentSong.singer
        songPicImageView.image = UIImage(named: currentSong.albumPic)
        songPageControl.numberOfPages = songs.count
        songPageControl.currentPage = currentIndex
        lyricsLabel.text = "\(currentSong.name)歌詞"
        lyricsLabel.sizeToFit()
        songSegmentedControl.selectedSegmentIndex = 0
        timeSlider.maximumValue = 0
        timeSlider.value = 0
        songPassTimeLabel.text = "00:00"
        songDurationLabel.text = "00:00"
        
        // 根據showingLyrics的值，自動切換視圖
        showingLyrics = false
        if showingLyrics {
            showLyricsView()
        } else {
            showSongPicView()
        }
        
        // 移除前一首歌曲的時間觀察器
        removeTimeObserver()
        
        // 切換歌曲
        replaceSong()
        
        // 重新加入時間觀察器
        addSongDuration()
    }
    
    // 切換歌曲
    func replaceSong() {
        let songUrl = Bundle.main.url(forResource: songs[currentIndex].songFile, withExtension: ".mp3")!
        let playerItem = AVPlayerItem(url: songUrl)
        player.replaceCurrentItem(with: playerItem)
    }
    
    // 播放歌曲
    func playSong() {
        playButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        if player.currentItem == nil {
            replaceSong()
        }
        player.play()
    }
    
    // 播放或暫停按鈕的IBAction
    @IBAction func play(_ sender: UIButton) {
        if player.timeControlStatus == .playing {
            sender.setBackgroundImage(UIImage(systemName: "arrowtriangle.right.circle.fill"), for: .normal)
            player.pause()
        } else {
            playSong()
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
    
    // 修改歌曲播放進度的IBAction
    @IBAction func changeTime(_ sender: UISlider) {
        
        if sender.isTracking {
            let isCurrentPlaying = player.timeControlStatus == .playing ? true : false
            if isCurrentPlaying {
                player.pause()
            }
            let time = CMTime(value: CMTimeValue(Int(sender.value)), timescale: 1)
            player.seek(to: time)
            if isCurrentPlaying {
                player.play()
            }
        }
    }
    
    // 隨機播放按鈕的IBAction
    @IBAction func onRandom(_ sender: UIButton) {
        isRandom = !isRandom
        logger.log("隨機嗎？\(self.isRandom)")
        
    }
    
    // 重複播放按鈕的IBAction
    @IBAction func onRepeat(_ sender: UIButton) {
        isRepeat = !isRepeat
        // 根據 isRepeat 的狀態來更改重複播放按鈕的圖示
        if isRepeat {
            sender.setImage(UIImage(systemName: "repeat.1"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "repeat"), for: .normal)
        }
    }
}

