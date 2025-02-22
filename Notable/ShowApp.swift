import UIKit
import GoogleMobileAds

class ShowApp: UIViewController, FullScreenContentDelegate {
    private var rewardedAd: RewardedAd?
    private let adUnitID = "ca-app-pub-3940256099942544/1712485313" // Replace with your AdMob Rewarded Ad unit ID

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadRewardedAd()
        
        let showAdButton = UIButton(type: .system)
        showAdButton.setTitle("Show Rewarded Ad", for: .normal)
        showAdButton.addTarget(self, action: #selector(showRewardedAd), for: .touchUpInside)
        showAdButton.frame = CGRect(x: 50, y: 200, width: 250, height: 50)
        view.addSubview(showAdButton)
    }

    func loadRewardedAd() {
        RewardedAd.load(with: adUnitID, request: Request()) { ad, error in
            if let error = error {
                print("Failed to load rewarded ad: \(error.localizedDescription)")
                return
            }
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
            print("Rewarded ad loaded successfully.")
        }
    }

    @objc func showRewardedAd() {
        if let ad = rewardedAd {
            ad.present(from: self) {
                let reward = ad.adReward
                print("User rewarded with \(reward.amount) \(reward.type)")
            }
        } else {
            print("Ad wasn't ready.")
            loadRewardedAd() // Attempt to reload the ad
        }
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("Ad dismissed. Loading new ad.")
        loadRewardedAd()
    }
}



