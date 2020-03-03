import UIKit
import SceneKit
import ARKit
import SpriteKit

class ViewController: UIViewController, ARSCNViewDelegate {

    var infos = [
    "ben": SCNText(string: "Benjamin Tyler \nAssociate Professor, Office 7E.423 \nEmail btyler@nu.edu.kz \nPhone +7 (7172) 706538", extrusionDepth: 1),
    "donald": SCNText(string:"Donald Trump \n45th President of  \nthe United States", extrusionDepth: 1)] as [String : SCNText]
    var photos = [
    "benPhoto" : "art.scnassets/ben.jpeg",
    "donaldPhoto" : "art.scnassets/donald.jpeg",
    "edTechPhoto" : "art.scnassets/edtech.jpg"
    ] as [String:String]

    @IBOutlet var sceneView: ARSCNView!
    
    //Store The Rotation Of The CurrentNode
    var currentAngleY: Float = 0.0
    
    //Not Really Necessary But Can Use If You Like
    var isSeen = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        if let arImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main) {
            
            configuration.detectionImages = arImages
            
            configuration.maximumNumberOfTrackedImages = 2
            
            print("Images Successfully Added")
        }
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARImageAnchor else { return }
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        
        
        //Text Node
        let nodeText = SCNNode()
        nodeText.position = SCNVector3(x: 0.12, y: -0.016, z: 0.075)
        nodeText.scale = SCNVector3(x:0.0007, y:0.0007, z:0.0007)
        nodeText.eulerAngles = SCNVector3(nodeText.eulerAngles.x + (-Float.pi / 2), nodeText.eulerAngles.y, nodeText.eulerAngles.z)
        
        let nodePhoto = SCNNode()
        nodePhoto.geometry = SCNPlane(width: 0.15, height: 0.15)
        nodePhoto.eulerAngles = SCNVector3(nodePhoto.eulerAngles.x + (-Float.pi / 2), nodePhoto.eulerAngles.y, nodePhoto.eulerAngles.z)
        nodePhoto.position = SCNVector3(x: 0.155, y: -0.012, z: -0.038)
        
        
        
        if let imageAnchor = anchor as? ARImageAnchor {
        // Text scene
            if imageAnchor.referenceImage.name == "554"{
                        print("This is code")
                        let text = infos["ben"]
                        
                        nodeText.geometry = text
                        text?.materials = [material]
                         
                        nodeText.name = "information_text"
                        //node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
                        nodeText.isHidden = false
                        node.addChildNode(nodeText)

                        // 4.
                        
                        nodePhoto.geometry?.firstMaterial?.diffuse.contents = photos["benPhoto"]
                        node.addChildNode(nodePhoto)
                        nodePhoto.name = "paint"
                        nodePhoto.isHidden=false
                            
                    }
            if imageAnchor.referenceImage.name == "USA" {
                let text = infos["donald"]
                
                nodeText.geometry = text
                text?.materials = [material]
                 
                nodeText.name = "information_text"
                //node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
                nodeText.isHidden = false
                node.addChildNode(nodeText)
                
                
                
                nodePhoto.geometry?.firstMaterial?.diffuse.contents = photos["donaldPhoto"]
                node.addChildNode(nodePhoto)
                nodePhoto.name = "paint"
                nodePhoto.isHidden=false
                
                }
            
            }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer){
        let tappedView = sender.view as! SCNView
        let touchLocation = sender.location(in: tappedView)
        let hitTest=tappedView.hitTest(touchLocation, options: nil)
        if !hitTest.isEmpty{
            let result = hitTest.first!
            let name = result.node.name
            let geometry = result.node.geometry
            if result.node.name == "information_text"{
                result.node.geometry = infos["donald"]
            }
            if result.node.name == "paint"{
                result.node.geometry?.firstMaterial?.diffuse.contents = photos["edTechPhoto"]
                }
            
            
            //}
            /*if result.node.parent!.opacity < CGFloat(1) {
               _ = result.node.parent?.runAction(SCNAction.fadeOpacity(to: 1, duration: 1))
            }*/
            print("\n \(String(describing: name)) \n \(String(describing: geometry))")
            }
            
        }
        
    }
