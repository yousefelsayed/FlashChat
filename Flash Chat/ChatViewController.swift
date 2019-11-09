//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate{
    
    // Declare instance variables here

    var  messageArray  :[Message] = [Message]()
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextfield.delegate = self
        
        //TODO: Set yourself as the delegate of the text field here:

        
        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tablViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
      configureTableView()
        retrieveMessages()
        messageTableView.separatorStyle = .none
        
    }
    func retrieveMessages()
      {
          let messageDB = Database.database().reference().child("Messages")
        
          messageDB.observe(.childAdded ,with:  { (snapShot) in
              let snapShotValue = snapShot.value as! Dictionary<String , String >
              let text = snapShotValue["MessageBody"]!
              let sender = snapShotValue["Sender"]!
             let message = Message()
            message.messageBody = text
            message.sender = sender
            self.messageArray.append(message)
            self.configureTableView()
            self.messageTableView.reloadData()
          })
      }
    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
             
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String?
        {
            cell.avatarImageView.backgroundColor = UIColor.blue
            cell.messageBackground.backgroundColor = UIColor.orange
        }
        else
        {
            cell.avatarImageView.backgroundColor = UIColor.green
                     cell.messageBackground.backgroundColor = UIColor.red
        }
               return cell
        
    }
       
    
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    
    //TODO: Declare tableViewTapped here:
    
    @objc func tablViewTapped()
    {
        messageTextfield.endEditing(false)
    }
    
    //TODO: Declare configureTableView here:
    func configureTableView()
        {
            messageTableView.rowHeight = UITableView.automaticDimension
            messageTableView.estimatedRowHeight = 120.0
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 365.0
            self.view.layoutIfNeeded()
        }
   
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
         UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50.0
                   self.view.layoutIfNeeded()
               }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    //TODO: Declare textFieldDidEndEditing here:
    

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        
        //TODO: Send the message to Firebase and save it in our database
       // messageTextfield.endEditing(false)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        let messagesDB = Database.database().reference().child("Messages")
        let messageDictionary = ["Sender" : Auth.auth().currentUser?.email ,
                                 "MessageBody" : messageTextfield.text!]
        messagesDB.childByAutoId().setValue(messageDictionary)
        {
            (error , refrence) in
            
                if error != nil
                {
                    print (error!)
                    
                }
                else
                {
                    print ("message sent sucessfully")
                    self.messageTextfield.isEnabled = true
                   self.sendButton.isEnabled = true
                    self.messageTextfield.text = ""
                }
        }
    
        

    //TODO: Create the retrieveMessages method here:
    
    
    
    
    
        func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
       
        do
        {
            
            try? Auth.auth().signOut()
            print("signout operation success")
            
        }
        catch{
            print ("an error when signout")
        }
      guard (  navigationController?.popToRootViewController(animated: true) != nil )
        else
      {
        print("can't find root of nav controller")
        return
        }
        
    }
    


}
}
