import UIKit

class HeroActionViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    var actionDetail: [ActionDetails] = []
    var heroID: Int?
    var heroType: HeroDetailsType?
    var currentPage = 0
    var total = 0
    var loadingAction = false
    lazy var noResultsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .gray
        label.text = "No results"
        return label
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = heroType?.path.capitalized
        collectionView.dataSource = self
        loadHeroes()
    }
    
    // MARK: - Class func
    
    class func instanceFromStoryboard() -> HeroActionViewController {
        let storyboard = UIStoryboard(name: "HeroAction", bundle: nil)
        return storyboard.instantiateInitialViewController() as! HeroActionViewController
    }
    
    // MARK: - Load functions
    
    func loadHeroes(withIndicator: Bool = true) {
        guard let heroID = heroID else { return }
        guard let artifactType = heroType else { return }
        
        setLoading(true, withIndicator: withIndicator)
        
        MarvelAPIManager.sharedInstance.getHeroDetail(type: artifactType, heroID: heroID, page: currentPage) {
            (result) in
            switch result {
            case .failure(let errorMessage):
                self.displayError(errorMessage)
            case .success(let artifactsContainer):
                guard let ActionDetails = artifactsContainer.results, let total = artifactsContainer.total else {
                    self.displayError("Requested failed")
                    return
                }
                
                self.total = total
                self.actionDetail += ActionDetails
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.setLoading(false, withIndicator: withIndicator)
            }
        }
    }
    
    // MARK: - Navigation
    
    func navToHeroDetails(with artifact: ActionDetails, artifactImage: UIImage?) {
        let controller = ActionDetailViewController.instanceFromStoryboard()
        controller.heroDetail = artifact
        controller.detailImage = artifactImage
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - Helpers

extension HeroActionViewController {
    func setLoading(_ loading: Bool, withIndicator: Bool) {
        loadingAction = loading
        if !withIndicator { return }
        
        /* From here with indicator */
        self.collectionView.isHidden = loading
        loading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}

