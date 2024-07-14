//
//  Strings.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 03.07.24.
//

import Foundation

struct Strings {
    /// user strings
    static let ageRangeString = NSLocalizedString("%@ in age of %@", comment: "String showing the desired gender and age preferences of a user")
    static let all = NSLocalizedString("All", comment: "All text")

    /// Notifications
    static let matchNotification = NSLocalizedString("You made a match with %@!", comment: "Match notification template")
    

    /// Bug Report - Settings
    static let reportBugTitle = NSLocalizedString("Bug Report", comment: "Bug Report Option title")
    static let bugReportFailed = NSLocalizedString("Your bug report could not be send... Please try it again later", comment: "Text describing that the bug report failed")
    static let bugReportSuccess = NSLocalizedString("Your bug report was successfully send", comment: "Text telling the user the bug report was successfully")
    static let reportBeeingSend = NSLocalizedString("Your report is beeing send. Hold on a second", comment: "Text indicating that the report is beeing send")
    static let successfullyReportedBug = NSLocalizedString("Your bug report was successful. We will take actions as soon as possible!", comment: "Message indicating the bug report was successful")
    static let reportBugPlaceholder = NSLocalizedString("Enter a detailed description about your issues...", comment: "Placeholder text for the bug report textfield")

    static let bugTypeHeader = NSLocalizedString("Choose the type of bug you experienced", comment: "Header text telling user to choose bug type to report")
    static let bugDescriptionSupport = NSLocalizedString("Descripe what exactly happened", comment: "Text telling the user to descripe what exactly happened while reporting a bug")
    static let bugReportAdditionalInfo = NSLocalizedString("(Optional) Provide us additional information", comment: "Text asking the user for additional information while bugreporting")
    static let bugReportAdditionalPlaceholder = NSLocalizedString("Enter any additional info that could help us to identify the bug", comment: "Bug report additional info placeholder for textfield")
    static let bugTypeTitleUI = NSLocalizedString("User Interface Issues", comment: "Problems with the user interface, such as layout errors or unexpected behavior of UI elements.")
    static let bugTypeTitlePerformance = NSLocalizedString("Performance Issues", comment: "Issues that affect the app's speed and responsiveness.")
    static let bugTypeTitleCrash = NSLocalizedString("App Crashes", comment: "Situations where the app unexpectedly quits.")
    static let bugTypeTitleNetwork = NSLocalizedString("Network Problems", comment: "Difficulties with network connections or loading content.")
    static let bugTypeTitleDataLoss = NSLocalizedString("Data Loss", comment: "Issues where user data is not saved or unexpectedly deleted.")
    static let bugTypeTitleFunctionality = NSLocalizedString("Functionality Issues", comment: "Features of the app do not function as intended.")
    static let bugTypeTitleSecurity = NSLocalizedString("Security Issues", comment: "Potential security risks that could endanger user privacy.")
    static let bugTypeTitleOther = NSLocalizedString("Other Issues", comment: "Other issues not listed above.")


    /// report user
    static let errorBlockMsg = NSLocalizedString("There was an error while blocking %@, please try again or report a bug", comment: "Error message when blocking a user fails")
    static let reportingText = NSLocalizedString("Reporting %@ ...", comment: "Message indicating that a user is being reported")
    static let reportError = NSLocalizedString("An error occurred and the user could not be reported. Please try again or make a bug report.", comment: "Error message indicating failure to report a user")
    static let sendReport = NSLocalizedString("Send Report", comment: "Button label to send a report")
    static let reasonForReport = NSLocalizedString("Tell us the reason why you want to report %@", comment: "Prompt asking for the reason to report a user")
    static let needMoreInfo = NSLocalizedString("We need more information on what exactly happened", comment: "Message indicating more information is needed")
    static let enterMoreInfo = NSLocalizedString("Enter more detailed information", comment: "Prompt to enter more detailed information")

    /// gpt error
    static let gptError = NSLocalizedString("There was an technical issue. Please try it again or if that doesn't help contact us.", comment: "Text describing that there were issues with chat gpt and telling the user to contact us.")


    /// authentification
    static let registrationFailed = NSLocalizedString("Registration failed: %@", comment: "Error message shown when registration fails")
    static let failedAuth = NSLocalizedString("Failed to authorize. Check your password or email.", comment: "Error message shown when authorization fails")
    static let createNewAccount = NSLocalizedString("Try to register again.", comment: "Prompt to try registering again")
    static let deleteAccError = NSLocalizedString("Unfortunately your account could not be deleted. Please try again or make a bug report.", comment: "Error message shown when account deletion fails")
    static let login = NSLocalizedString("Login", comment: "Login button text")
    static let logout = NSLocalizedString("Logout", comment: "Logout button text")
    static let register = NSLocalizedString("Register", comment: "Register button text")
    static let signInOptions = NSLocalizedString("Sign in options", comment: "Text for sign-in options")

    /// likes view
    static let noLikes = NSLocalizedString("Seems like you have no likes yet.", comment: "Message indicating the user has no likes")
    static let noLikedUsers = NSLocalizedString("You have not liked any users yet.", comment: "Message indicating the user has not liked any users")
    static let noMatches = NSLocalizedString("You have 0 matches right now.", comment: "Message indicating the user has no matches")
    static let goToSwipe = NSLocalizedString("Do you want to swipe?", comment: "Prompt asking if the user wants to swipe")

    /// messages view
    static let loadingChats = NSLocalizedString("Your chats are beeing loaded...", comment: "Text indicating that the chats of current users are beeing loaded.")
    static let gptInfoText = NSLocalizedString("SoulDating lets you interact with OpenAI ChatGPT! You can either let GPT create pickup lines for you or start a conversation to learn more about dating!", comment: "Information about interacting with OpenAI ChatGPT")
    static let enterMessage = NSLocalizedString("Enter a message", comment: "Prompt to enter a message")
    static let createPickupLines = NSLocalizedString("Create Pickup Lines", comment: "Button label to create pickup lines")
    static let askGPT = NSLocalizedString("Ask ChatGPT", comment: "Button label to ask ChatGPT")
    /// Radar View
    static let radarFetchError = NSLocalizedString("Failed to lookup for users in your radius", comment: "Error message indicating failure to fetch users within the radius")
    static let radarNoUsers = NSLocalizedString("No users found that matches your preferences...", comment: "Message indicating that there are no users in found in RadarView that matches users preferences")
    static let goToProfileTab = NSLocalizedString("Go to Profile Tab?", comment: "Message asking the user if he wants to enter the profile Tab")
    static let noMessages = NSLocalizedString("You don't have any messages with other users", comment: "Text indicating that there exists no chats for the current user")


    /// FirebaseError
    static let notLoggedIn = NSLocalizedString("User is not logged in", comment: "Error message when user is not logged in")
    static let notLoggedInMsg = NSLocalizedString("Oops! You are not logged in. If this should not be the case submit a bugreport.", comment: "Detailed message when user is not logged in")
    static let downloadUrlFail = NSLocalizedString("URL of the picture couldn't be downloaded", comment: "Error message when picture URL cannot be downloaded")
    static let downloadUrlFailMsg = NSLocalizedString("We couldn't download the image from the server... Please check your connection and try again", comment: "Detailed message when picture URL download fails")
    static let noPictureChosen = NSLocalizedString("No image chosen or the image could not be set to the variable", comment: "Error message when no image is chosen")
    static let noPictureChosenMsg = NSLocalizedString("An error occured and it seems you have no image selected, try again", comment: "Detailed message when no image is chosen")
    static let convertError = NSLocalizedString("An error occured while converting", comment: "Error message when conversion fails")
    static let convertErrorMsg = NSLocalizedString("Something went wrong... Please try again or submit a bugreport.", comment: "Detailed message when conversion fails")


    /// Settings View
    static let settingsTitle = NSLocalizedString("Settings", comment: "Title for settings screen")
    static let accSettingsTitle = NSLocalizedString("Account Settings", comment: "Title for account settings section")
    static let accSectionHeader = NSLocalizedString("Account", comment: "Header for account section")
    static let personalDetailHeader = NSLocalizedString("Personal Details", comment: "Header for personal details section")


    /// notification settings
    static let notificationSectionHeader = NSLocalizedString("Notification Settings", comment: "Header for notification settings section")
    static let allowNotifications = NSLocalizedString("Allow Notification", comment: "Text for allowing notifications")


    // age range
    static let chooseAgeRange = NSLocalizedString("Choose your desired ages", comment: "Prompt to choose desired age range")
    static let currentAges = NSLocalizedString("Current %@ - %@", comment: "Text displaying the current age range")


    // edit user
    static let enterDescText = NSLocalizedString("Enter a short description about yourself for other users", comment: "Prompt for entering a short description about the user")
    static let changeDescription = NSLocalizedString("Change your description", comment: "Option to change the user's description")
    static let enterMoreDesc = NSLocalizedString("Enter a more detailed description.", comment: "Prompt for entering a more detailed description about the user")
    static let updateLocationRadius = NSLocalizedString("Update your location & radius", comment: "Option to update the user's location and radius")
    static let willUpdateSuggestions = NSLocalizedString("This will change your user suggestions", comment: "Message indicating that updating location and radius will change user suggestions")
    static let willChangeOtherSuggestions = NSLocalizedString("This will change how you are suggested to others", comment: "Message indicating that updating location and radius will change how the user is suggested to others")
    static let descriptionHelpText = NSLocalizedString("A good description can help you find more matches, write something special about you.", comment: "Help text for writing a good description")
    static let enterAddress = NSLocalizedString("Enter your approximate address", comment: "Prompt for entering the user's approximate address")


    // profile edit user titles / edit titles
    // profile tab
    static let aboutYouTitle = NSLocalizedString("About you", comment: "Title for the 'About you' section")
    static let preferencesTitle = NSLocalizedString("Preferences", comment: "Title for the 'Preferences' section")
    static let photosTitle = NSLocalizedString("Photos", comment: "Title for the 'Photos' section")


    // about you section
    static let generalTitle = NSLocalizedString("General Information", comment: "Title for the 'General Information' section")
    static let lookAndLifestyleTitle = NSLocalizedString("Look & Lifestyle", comment: "Title for the 'Look & Lifestyle' section")
    static let moreAboutYouTitle = NSLocalizedString("More about you", comment: "Title for the 'More about you' section")

    // general item enum
    static let noLocationSet = NSLocalizedString("No location set", comment: "Text indicating that the user has no location saved.")
    static let enterNamePlaceholder = NSLocalizedString("Enter your name", comment: "Placeholder text for entering the user's name")
    static let noDescriptionText = NSLocalizedString("%@ has no description yet", comment: "Text indicating that the user has no description yet.")
    static let enterDescriptionPlaceholder = NSLocalizedString("Enter a description about you", comment: "Placeholder text for entering a description about the user")
    static let updateName = NSLocalizedString("Update your name", comment: "Option to update the user's name")
    static let updatebirth = NSLocalizedString("Update your date of birth", comment: "Option to update the user's date of birth")
    static let updateOwnGender = NSLocalizedString("Update your current gender", comment: "Option to update the user's current gender")
    static let updateSexuality = NSLocalizedString("Update your sex identity", comment: "Option to update the user's sexual identity")
    static let updateDescription = NSLocalizedString("Update your description", comment: "Option to update the user's description")
    static let yourLocation = NSLocalizedString("Your location", comment: "Title for the user's location section")
    static let descriptionTitle = NSLocalizedString("Description about yourself", comment: "Title for the user's description section")

    
    // look and lifestyle item enum
    static let yourHeight = NSLocalizedString("Your height", comment: "Title for the user's height section")
    static let updateYourHeight = NSLocalizedString("Update your height", comment: "Option to update the user's height")
    static let yourBodyType = NSLocalizedString("Your body type", comment: "Title for the user's body type section")
    static let updateBodyType = NSLocalizedString("Update your body type", comment: "Option to update the user's body type")
    static let yourJob = NSLocalizedString("Your current job", comment: "Title for the user's current job section")
    static let updateJob = NSLocalizedString("Update your current job", comment: "Option to update the user's current job")
    static let education = NSLocalizedString("Education", comment: "Title for the user's education section")
    static let interests = NSLocalizedString("Interests", comment: "Title for the user's interests section")
    static let noInterestsProvided = NSLocalizedString("No interests provided", comment: "Text that displays that the user has no interests provided.")
    static let smoker = NSLocalizedString("Smoker", comment: "Title for the user's smoking status section")
    static let bodyType = NSLocalizedString("Body Type", comment: "Title for the user's body type section")
    static let yourEducation = NSLocalizedString("Your education level", comment: "Title for the user's education level section")
    static let updateEducation = NSLocalizedString("Update your level of education", comment: "Option to update the user's level of education")
    static let drinkingBehaviour = NSLocalizedString("Drinking Behaviour", comment: "Drinking Behaviour label")
    static let yourDrinkingBehaviour = NSLocalizedString("Your alcoholic behaviour", comment: "Title for the user's alcoholic behaviour section")
    static let updateDrinking = NSLocalizedString("Update your alcoholic behaviour", comment: "Option to update the user's alcoholic behaviour")
    static let smokingBehaviour = NSLocalizedString("Smoking behaviour", comment: "Smoking behaviour label text")
    static let yourSmokingBehaviour = NSLocalizedString("Do you smoke?", comment: "Title for the user's smoking behaviour section")
    static let updateSmoking = NSLocalizedString("Update your smoking status", comment: "Option to update the user's smoking status")
    static let jobPlaceholder = NSLocalizedString("Enter your jobname", comment: "Placeholder text for entering the user's job name")

    // report reasons
    static let inappropriatePicture = NSLocalizedString("Inappropriate Picture", comment: "Report reason for inappropriate picture")
    static let harrassmentOrMobbing = NSLocalizedString("Harassment or Mobbing", comment: "Report reason for harassment or mobbing")
    static let spam = NSLocalizedString("Spam or Advertising", comment: "Report reason for spam or advertising")
    static let fakeProfile = NSLocalizedString("Fake Profile or Identity", comment: "Report reason for fake profile or identity")
    static let scam = NSLocalizedString("Scam or deception", comment: "Report reason for scam or deception")
    static let offensiveLanguage = NSLocalizedString("Offensive or insulting language", comment: "Report reason for offensive or insulting language")
    static let unwantedApproaches = NSLocalizedString("Unwanted approaches", comment: "Report reason for unwanted approaches")

    static let inappropriatePictureDescription = NSLocalizedString("The user has posted inappropriate or offensive images.", comment: "Description for inappropriate picture report reason")
    static let harrassmentOrMobbingDescription = NSLocalizedString("The user is engaging in harassment or bullying behavior.", comment: "Description for harassment or mobbing report reason")
    static let spamDescription = NSLocalizedString("The user is sending spam or advertising content.", comment: "Description for spam report reason")
    static let fakeProfileDescription = NSLocalizedString("The user has a fake profile or is using a false identity.", comment: "Description for fake profile report reason")
    static let scamDescription = NSLocalizedString("The user is involved in fraudulent or deceptive activities.", comment: "Description for scam report reason")
    static let offensiveLanguageDescription = NSLocalizedString("The user is using offensive or abusive language.", comment: "Description for offensive language report reason")
    static let unwantedApproachesDescription = NSLocalizedString("The user is making unwanted approaches.", comment: "Description for unwanted approaches report reason")
    static let otherDescription = NSLocalizedString("Other reason.", comment: "Description for other report reason")

    // Report enum
    static let blockTitle = NSLocalizedString("Report %@", comment: "Title for reporting a user")
    static let blockReportTitle = NSLocalizedString("Block and Report %@", comment: "Title for blocking and reporting a user")
    static let confirmationBlock = NSLocalizedString("Do you really want to block %@?", comment: "Confirmation message for blocking a user")
    static let confirmationReport = NSLocalizedString("Do you really want to report and block %@?", comment: "Confirmation message for reporting and blocking a user")
    static let confirmationMsgBlock = NSLocalizedString("You can unblock %@ at every time.", comment: "Message indicating that the user can be unblocked at any time")
    static let confirmationMsgReport = NSLocalizedString("You can unblock %@ at every time, but your report cannot be undone!", comment: "Message indicating that the user can be unblocked at any time but the report cannot be undone")

    // more about you item enum
    static let interestsTitle = NSLocalizedString("Your interests", comment: "Title for the user's interests section")
    static let interestsEdit = NSLocalizedString("Update your interests", comment: "Option to update the user's interests")
    static let languagesTitle = NSLocalizedString("Your spoken languages", comment: "Title for the user's spoken languages section")
    static let noLanguagesProvided = NSLocalizedString("No languages selected", comment: "Text signalizing that the user has no languages selected or provided yet.")
    static let languagesEdit = NSLocalizedString("Update which languages you speak", comment: "Option to update the user's spoken languages")
    static let fashionStyle = NSLocalizedString("Fashion Style", comment: "Fashion Style label")
    static let fashionStyleTitle = NSLocalizedString("Your fashion style", comment: "Title for the user's fashion style section")
    static let fashionstyleEdit = NSLocalizedString("Update what kind of fashion you prefer", comment: "Option to update the user's fashion style")
    static let fitnessLevelTitle = NSLocalizedString("How fit are you?", comment: "Title for the user's fitness level section")
    static let fitnessLevelEdit = NSLocalizedString("Update your fitness level", comment: "Option to update the user's fitness level")

    // preference section enum
    static let datingPrefTitle = NSLocalizedString("Dating Preferences", comment: "Title for the dating preferences section")
    static let lifestylePrefTitle = NSLocalizedString("Lifestyle Preferences", comment: "Title for the lifestyle preferences section")

    // dating pref
    static let relationshipTitle = NSLocalizedString("Looking for", comment: "Title for the 'looking for' section")
    static let relationshipTitleEdit = NSLocalizedString("What kind of relationship type fits you the most?", comment: "Prompt for updating the user's relationship type preference")
    static let prefGenderTitle = NSLocalizedString("Your preferred genders", comment: "Title for the user's preferred genders section")
    static let prefGenderTitleEdit = NSLocalizedString("Update which genders you prefer", comment: "Option to update the user's preferred genders")
    static let prefAgeTitle = NSLocalizedString("Your preferred age span", comment: "Title for the user's preferred age span section")
    static let prefHeightTitle = NSLocalizedString("Your preferred height", comment: "Title for the user's preferred height section")

    // life style pref
    static let acceptsSmokerTitleEdit = NSLocalizedString("Do you date smokers?", comment: "Prompt for whether the user dates smokers")
    static let acceptsDrinkerTitleEdit = NSLocalizedString("Do you accept drinkers?", comment: "Prompt for whether the user accepts drinkers")
    static let wantsChildsTitleEdit = NSLocalizedString("Do you want children?", comment: "Prompt for whether the user wants children")
    static let wantsSportyPartnerTitleEdit = NSLocalizedString("Should your partner do sports?", comment: "Prompt for whether the user wants a sporty partner")

    /// photos context options
    static let share = NSLocalizedString("Share", comment: "Option to share a photo")
    static let download = NSLocalizedString("Download", comment: "Option to download a photo")
    static let delete = NSLocalizedString("Delete", comment: "Option to delete a photo")
    static let moveFirst = NSLocalizedString("Move to first position", comment: "Option to move a photo to the first position")
    static let moveLast = NSLocalizedString("Move to last position", comment: "Option to move a photo to the last position")
    static let selectAsPicture = NSLocalizedString("Select as display picture", comment: "Option to select a photo as the display picture")

    /// photos
    static let chooseUploadMethod = NSLocalizedString("Choose an option to upload your photo", comment: "Prompt for choosing an upload method for the photo")
    static let updateMainPic = NSLocalizedString("Update main picture", comment: "Option to update the main picture")
    static let selectMainPic = NSLocalizedString("Select main picture", comment: "Option to select the main picture")

    /// onboarding
    static let accBeeingCreated = NSLocalizedString("Your account is being created and your details saved! Hold on a second.", comment: "Message indicating the account is being created")
    static let accWasCreated = NSLocalizedString("Your new account was created. You can continue with SoulDating!", comment: "Message indicating the account was successfully created")
    static let welcome = NSLocalizedString("Welcome!", comment: "Welcome message")
    static let letsGetStarted = NSLocalizedString("Let's get started", comment: "Prompt to start the onboarding process")
    static let whatsName = NSLocalizedString("What is your name?", comment: "Prompt to ask for the user's name")
    static let pictureInfoText = NSLocalizedString("You can use the well known swipe gestures to resize your image.\n You can also move your Picture or turn it around.", comment: "Instructions for editing the profile picture")
    static let moreInfoSubTitle = NSLocalizedString("This information is used to suggest users to you and provide better suggestions for other users.", comment: "Subtitle explaining the purpose of collecting more information")
    static let tellBirthDate = NSLocalizedString("Tell us your date of birth", comment: "Prompt to ask for the user's date of birth")
    static let unexpectedErrorOccured = NSLocalizedString("An unexpected error occurred. Please try again or report a bug.", comment: "Message indicating an unexpected error occurred")
    static let unexpectedCriticalBug = NSLocalizedString("Unfortunately there happened a critical bug. We can't create an account for you. If you have not already, please report us this bug so that we can investigate what happened.", comment: "Message indicating a critical bug occurred and account creation failed")
    static let uploadPic = NSLocalizedString("Upload picture", comment: "Prompt to upload a picture")
    static let imageHelpText = NSLocalizedString("Your image should nearly fit in this rectangle", comment: "Guidance for fitting the image into the designated area")

    /// other user view
    static let fetchOtherUserError = NSLocalizedString("An error occurred and the user data could not be load. Please try it again or make a bug report.", comment: "Message indicating an error occurred while loading other user data")
    static let aboutMe = NSLocalizedString("About me", comment: "Section title for information about the user")
    static let otherPhotos = NSLocalizedString("Other photos", comment: "Section title for other photos of the user")
    static let job = NSLocalizedString("Job", comment: "Job text")

    /// update error
    static let updateUserError = NSLocalizedString("We could not update your profile... Please try again or make a bug report.", comment: "Message indicating an error occurred while updating the profile")
    static let updateLangError = NSLocalizedString("We could not save your selected languages... Please try again or make a bug report.", comment: "Message indicating an error occurred while saving the selected languages")
    static let updateLocationSelection = NSLocalizedString("An error occurred while saving your selection", comment: "Message indicating an error occurred while saving the location selection")

    /// sorting
    static let ascending = NSLocalizedString("Ascending", comment: "Sorting order: Ascending")
    static let descending = NSLocalizedString("Descending", comment: "Sorting order: Descending")
    static let sortOrder = NSLocalizedString("Sort order", comment: "Label for sorting order")
    static let sortBy = NSLocalizedString("Sort by", comment: "Label for sorting by a specific attribute")
    static let toggleSort = NSLocalizedString("Toggle Sort Order", comment: "Button label to toggle the sorting order")

    /// filtering
    static let filterBy = NSLocalizedString("Filter by", comment: "Label for filtering by a specific attribute")
    static let showOnly = NSLocalizedString("Show only", comment: "Label for showing only specific items")
    static let options = NSLocalizedString("Options", comment: "Label for various options")

    /// likes
    static let yourLikes = NSLocalizedString("Your likes", comment: "Label for items liked by the user")
    static let likedUsers = NSLocalizedString("Liked Users", comment: "Label for users liked by the user")
    static let matches = NSLocalizedString("Matches", comment: "Label for matches")

    /// images
    static let saveImageError = NSLocalizedString("Your image could not be saved... please try it again or make a bug report.", comment: "Error message when an image could not be saved")
    static let deleteImageError = NSLocalizedString("Unfortunately we could not delete your image, please try again or contact us.", comment: "Error message when an image could not be deleted")
    static let noOtherImages = NSLocalizedString("Seems like you don't have any other images uploaded...", comment: "Message indicating no other images are uploaded")
    static let goToPhotosTab = NSLocalizedString("Go to Photos Tab?", comment: "Prompt to go to the Photos tab")

    /// languages
    static let getLangFileError = NSLocalizedString("An error occured and the languages could not be loaded. Please try again or make a bug report.", comment: "Error message when languages could not be loaded")

    /// swipe
    static let saveSwipeError = NSLocalizedString("We could not save your %@. Please try again or make a bug report.", comment: "Error message when a swipe could not be saved")
    static let fetchSwipeError = NSLocalizedString("An error occured while fetching new people for you...", comment: "Error message when there is an error fetching new people")
    static let noSwipeUsers = NSLocalizedString("Unfortunately there are no more users in your area...", comment: "Message indicating there are no more users in the area")
    static let fetchingUser = NSLocalizedString("Trying to fetch new users...", comment: "Message indicating an attempt to fetch new users")
    static let fetchAgain = NSLocalizedString("Try to fetch users again", comment: "Prompt to try fetching users again")
    static let changeAgeSpan = NSLocalizedString("Or change the age span?", comment: "Prompt to change the age span")
    static let writeMsgTo = NSLocalizedString("Write a message to %@", comment: "Prompt to write a message to a user")
    static let openProfile = NSLocalizedString("Open %@'s Profile", comment: "Prompt to open a user's profile")
    static let haveMatchWith = NSLocalizedString("You have a match with %@!", comment: "Message indicating a match with a user")

    /// common
    static let attention = NSLocalizedString("Attention", comment: "Common label for attention")
    static let back = NSLocalizedString("Back", comment: "Common label for back")
    static let birthDate = NSLocalizedString("Birthdate", comment: "Common label for birthdate")
    static let block = NSLocalizedString("Block", comment: "Common label for block")
    static let continues = NSLocalizedString("Continue", comment: "Common label for continue")
    static let camera = NSLocalizedString("Camera", comment: "Common label for camera")
    static let cancel = NSLocalizedString("Cancel", comment: "Common label for cancel")
    static let chooseGender = NSLocalizedString("Choose your gender", comment: "Common label for choosing gender")
    static let choosePrefGender = NSLocalizedString("Choose your preferred gender(s)", comment: "Common label for choosing preferred gender(s)")
    static let error = NSLocalizedString("Error", comment: "Common label for error")
    static let gender = NSLocalizedString("Gender", comment: "Common label for gender")
    static let finish = NSLocalizedString("Finish", comment: "Common label for finish")
    static let email = NSLocalizedString("Email address", comment: "Common label for email address")
    static let enterMail = NSLocalizedString("Enter e-mail address", comment: "Prompt to enter e-mail address")
    static let enterNewMail = NSLocalizedString("Enter your new e-mail address", comment: "Prompt to enter new e-mail address")
    static let enterNewPassword = NSLocalizedString("Enter your new password", comment: "Prompt to enter new password")
    static let enterOldPassword = NSLocalizedString("Enter your old password", comment: "Prompt to enter old password")
    static let enterPassword = NSLocalizedString("Enter your password", comment: "Prompt to enter password")
    static let enterValidMail = NSLocalizedString("Enter a valid e-mail address", comment: "Prompt to enter a valid e-mail address")
    static let hideYourself = NSLocalizedString("Hide yourself", comment: "Common label for hiding yourself")
    static let hideUserProfile = NSLocalizedString("Hide your profile", comment: "Common label for hiding user profile")
    static let hideSupportText = NSLocalizedString("If you hide yourself, other users cannot find you anywhere in the app, but users you have already chats with can still message you.", comment: "Explanation of what happens when you hide your profile")
    static let library = NSLocalizedString("Library", comment: "Common label for library")
    static let new = NSLocalizedString("New", comment: "Common label for new")
    static let notNow = NSLocalizedString("Not now", comment: "Common label for not now")
    static let notSpecified = NSLocalizedString("Not specified", comment: "Common label for not specified")
    static let password = NSLocalizedString("Password", comment: "Common label for password")
    static let repeatPassword = NSLocalizedString("Repeat password", comment: "Common label for repeat password")
    static let retry = NSLocalizedString("Try again", comment: "Common label for retry")
    static let save = NSLocalizedString("Save", comment: "Common label for save")
    static let send = NSLocalizedString("Send", comment: "Send action label")
    static let start = NSLocalizedString("Start", comment: "Common label for start")
    static let success = NSLocalizedString("Success", comment: "Common label for success")
    static let update = NSLocalizedString("Update", comment: "Common label for update")
    static let userName = NSLocalizedString("Username", comment: "Common label for username")
    static let distanceValue = NSLocalizedString("%@ away", comment: "Format for displaying distance")
    static let age = NSLocalizedString("Age", comment: "Common label for age")
    static let name = NSLocalizedString("Name", comment: "Common label for name")
    static let distance = NSLocalizedString("Distance", comment: "Common label for distance")
    static let none = NSLocalizedString("None", comment: "Common label for none")
    static let sexuality = NSLocalizedString("Sexuality", comment: "Common label for sexuality")

    /// placeholder texts
    static let locationValue = NSLocalizedString("Location %@", comment: "Format for displaying location")
    static let genderValue = NSLocalizedString("Gender %@", comment: "Format for displaying gender")
    static let jobValue = NSLocalizedString("Job %@", comment: "Format for displaying job")
    static let heightValue = NSLocalizedString("Height %@", comment: "Format for displaying height")

    /// textfield error texts
    static let atleast3Chars = NSLocalizedString("Your name must have at least 3 characters", comment: "Error message indicating the name must have at least 3 characters")
    static let min16 = NSLocalizedString("You must be at least 18 years old...", comment: "Error message indicating the user must be at least 18 years old")

    /// textfield texts
    static let publicName = NSLocalizedString("This will be your public profile name", comment: "Prompt indicating this will be the user's public profile name")

    /// textfield error texts
    static let emailHelpText = NSLocalizedString("Your e-mail address should be at least 6 chars long.", comment: "Help text indicating the e-mail address should be at least 6 characters long")
    static let passwordHelpText = NSLocalizedString("Your password must be at least 6 chars long.", comment: "Help text indicating the password should be at least 6 characters long")


    /// messages errors
    static let sendMsgErrorTitle = NSLocalizedString("Could not send your message", comment: "Error title indicating message could not be sent")
    static let sendMsgErrorMessage = NSLocalizedString("Please try it again or make a bug report.", comment: "Error message indicating to try again or make a bug report")
    static let unexpectedErrorTitle = NSLocalizedString("An unexpected error occurred...", comment: "Error title for unexpected error")
    static let unexpectedErrorMsg = NSLocalizedString("The messages could not be found, please try again or make a bug report.", comment: "Error message indicating messages could not be found")
    static let fetchUserError = NSLocalizedString("The user could not be loaded. Please try again or make a bug report.", comment: "Error message indicating user could not be loaded")

    /// GPT-MESSAGES
    static let gptPrompt = NSLocalizedString("""
        Please generate exactly five pickup lines, numbered 1 through 5. Each pickup line should be enclosed in quotation marks, without any extra quotation marks around the entire response or additional text. Ensure the format is adhered to strictly with each line on a new line, like this:

        1. "Example of a pickup line"
        2. "Example of a pickup line"
        3. "Example of a pickup line"
        4. "Example of a pickup line"
        5. "Example of a pickup line"

        Please output the pickup lines individually, following the numbering precisely, and make sure no additional formatting or characters are included outside of the required quotation marks and text.

        Also try to match the pickup line if possible with the following user details:
        """, comment: "Prompt for generating pickup lines using GPT")
    static let generatingMessages = NSLocalizedString("Hold on. Awesome pickup lines are being generated for you!", comment: "Message indicating pickup lines are being generated")
    static let chooseLine = NSLocalizedString("Choose your favorite pickup line!", comment: "Prompt to choose favorite pickup line")
    static let chooseRandomLine = NSLocalizedString("Choose random line", comment: "Option to choose a random pickup line")
    static let pickupLineTitle = NSLocalizedString("Pickup lines generator", comment: "Title for the pickup lines generator")



    /// SETTINGS
    static let updateEmailError = NSLocalizedString("The verification mail could not be sent. Try again or make a bug report.", comment: "Error message indicating failure to send verification email")
    static let updateEmailInfo = NSLocalizedString("You will be signed out if you attempt to update your e-mail. You will receive a link to your current email address. If you decide not to change your e-mail, just log in again.", comment: "Information about updating email address")
    static let updatePwError = NSLocalizedString("An error occurred while updating your password. Please try again or do a bug report.", comment: "Error message indicating failure to update password")
    static let deleteAccount = NSLocalizedString("Delete your Account", comment: "Option to delete the account")
    static let deleteAccountInfo = NSLocalizedString("Do you really want to delete your account and all stored chats and images you made? This cannot be undone!", comment: "Confirmation message for deleting the account")
    static let accountDeleted = NSLocalizedString("Your account has been successfully deleted.", comment: "Message indicating the account was successfully deleted")
    static let changePw = NSLocalizedString("Change your password", comment: "Option to change the password")
    static let changingPw = NSLocalizedString("Your password is being changed", comment: "Message indicating the password is being changed")
    static let changedPwSuccess = NSLocalizedString("Successfully changed your password!", comment: "Message indicating the password was successfully changed")
    static let changeMail = NSLocalizedString("Change your e-mail address", comment: "Option to change the email address")
    static let linkToEmailSending = NSLocalizedString("A link is being sent to your new email address", comment: "Message indicating a link is being sent to the new email address")
    static let checkInbox = NSLocalizedString("Check the inbox of your mail to update your email address and log in again then.", comment: "Prompt to check the email inbox for the update link")

    /// Tab enums
    static let swipeTitle = NSLocalizedString("Swipe", comment: "Title for the Swipe tab")
    static let likesTitle = NSLocalizedString("Likes", comment: "Title for the Likes tab")
    static let messagesTitle = NSLocalizedString("Messages", comment: "Title for the Messages tab")
    static let radarTitle = NSLocalizedString("Radar", comment: "Title for the Radar tab")
    static let profileTitle = NSLocalizedString("Profile", comment: "Title for the Profile tab")

    /// app setting section enum
    static let appSettings = NSLocalizedString("App Settings", comment: "Title for the App Settings section")
    static let problems = NSLocalizedString("Problems or questions?", comment: "Section title for problems or questions")
    static let juridical = NSLocalizedString("Juristics", comment: "Section title for juridical information")


    // body type enum
    static let slimBody = NSLocalizedString("Slim", comment: "Body type: Slim")
    static let avgBody = NSLocalizedString("Average", comment: "Body type: Average")
    static let athleticBody = NSLocalizedString("Athletic", comment: "Body type: Athletic")
    static let heavysetBody = NSLocalizedString("Heavyset", comment: "Body type: Heavyset")


    // other user profile view
    static let drinker = NSLocalizedString("Drinker", comment: "Drinker text")
    static let smokers = NSLocalizedString("Smoker", comment: "Smoker text")
    static let childs = NSLocalizedString("Childs", comment: "Childs text")

    // drinking behaviour enum
    static let nonDrinker = NSLocalizedString("Non-drinker", comment: "Drinking behaviour: Non-drinker")
    static let socialDrinker = NSLocalizedString("Social drinker", comment: "Drinking behaviour: Social drinker")
    static let regularDrinker = NSLocalizedString("Regular drinker", comment: "Drinking behaviour: Regular drinker")

    // education enum
    static let highSchool = NSLocalizedString("High School", comment: "Education level: High School")
    static let someCollege = NSLocalizedString("Some College", comment: "Education level: Some College")
    static let associateDegree = NSLocalizedString("Associate Degree", comment: "Education level: Associate Degree")
    static let bachelor = NSLocalizedString("Bachelors Degree", comment: "Education level: Bachelor's Degree")
    static let masterDegree = NSLocalizedString("Master's Degree", comment: "Education level: Master's Degree")
    static let doctoralDegree = NSLocalizedString("Doctoral Degree", comment: "Education level: Doctoral Degree")
    static let professionalDegree = NSLocalizedString("Professional Degree", comment: "Education level: Professional Degree")

    // exercise frequency enum
    static let never = NSLocalizedString("Never", comment: "Exercise frequency: Never")
    static let occasionally = NSLocalizedString("Occasionally", comment: "Exercise frequency: Occasionally")
    static let regularly = NSLocalizedString("Regularly", comment: "Exercise frequency: Regularly")

    // gender enum
    static let male = NSLocalizedString("Male", comment: "Gender: Male")
    static let maleSecondary = NSLocalizedString("Men", comment: "Gender: Men")
    static let female = NSLocalizedString("Female", comment: "Gender: Female")
    static let femaleSecondary = NSLocalizedString("Woman", comment: "Gender: Woman")
    static let divers = NSLocalizedString("Diverse", comment: "Gender: Diverse")
    static let diversSecondary = NSLocalizedString("Non-Binary", comment: "Gender: Non-Binary")

    // fashion style enum
    static let casual = NSLocalizedString("Casual", comment: "Fashion style: Casual")
    static let business = NSLocalizedString("Business Casual", comment: "Fashion style: Business Casual")
    static let formal = NSLocalizedString("Formal", comment: "Fashion style: Formal")
    static let sporty = NSLocalizedString("Sporty", comment: "Fashion style: Sporty")
    static let eclectic = NSLocalizedString("Eclectic", comment: "Fashion style: Eclectic")
    static let vintage = NSLocalizedString("Vintage", comment: "Fashion style: Vintage")
    static let streetwear = NSLocalizedString("Streetwear", comment: "Fashion style: Streetwear")
    static let chic = NSLocalizedString("Chic", comment: "Fashion style: Chic")

    // fitness level enum
    static let fitnessLevel = NSLocalizedString("Fitness Level", comment: "Fitness Level label")
    static let unfit = NSLocalizedString("Very rarely", comment: "Fitness level: Very rarely")
    static let lightly = NSLocalizedString("Sometimes", comment: "Fitness level: Sometimes")
    static let moderateActive = NSLocalizedString("Regularly doing Sports", comment: "Fitness level: Regularly doing Sports")
    static let veryActive = NSLocalizedString("Daily doing Sports", comment: "Fitness level: Daily doing Sports")
    static let athlete = NSLocalizedString("Professional sportsman", comment: "Fitness level: Professional sportsman")

    // interests enum
    static let animals = NSLocalizedString("Animals", comment: "Interest: Animals")
    static let art = NSLocalizedString("Art", comment: "Interest: Art")
    static let astrology = NSLocalizedString("Astrology", comment: "Interest: Astrology")
    static let birdwatching = NSLocalizedString("Birdwatching", comment: "Interest: Birdwatching")
    static let cooking = NSLocalizedString("Cooking", comment: "Interest: Cooking")
    static let dancing = NSLocalizedString("Dancing", comment: "Interest: Dancing")
    static let diy = NSLocalizedString("Do It Yourself", comment: "Interest: Do It Yourself")
    static let fashion = NSLocalizedString("Fashion", comment: "Interest: Fashion")
    static let fitness = NSLocalizedString("Fitness", comment: "Interest: Fitness")
    static let gaming = NSLocalizedString("Gaming", comment: "Interest: Gaming")
    static let gardening = NSLocalizedString("Gardening", comment: "Interest: Gardening")
    static let hiking = NSLocalizedString("Hiking", comment: "Interest: Hiking")
    static let history = NSLocalizedString("History", comment: "Interest: History")
    static let knitting = NSLocalizedString("Knitting", comment: "Interest: Knitting")
    static let meditation = NSLocalizedString("Meditation", comment: "Interest: Meditation")
    static let music = NSLocalizedString("Music", comment: "Interest: Music")
    static let movies = NSLocalizedString("Movies", comment: "Interest: Movies")
    static let photography = NSLocalizedString("Photography", comment: "Interest: Photography")
    static let politics = NSLocalizedString("Politics", comment: "Interest: Politics")
    static let reading = NSLocalizedString("Reading", comment: "Interest: Reading")
    static let sports = NSLocalizedString("Sports", comment: "Interest: Sports")
    static let traveling = NSLocalizedString("Traveling", comment: "Interest: Traveling")
    static let technology = NSLocalizedString("Technology", comment: "Interest: Technology")
    static let volunteering = NSLocalizedString("Volunteering", comment: "Interest: Volunteering")
    static let writing = NSLocalizedString("Writing", comment: "Interest: Writing")

    // relationship enum
    static let relationshipFriendships = NSLocalizedString("Friendships", comment: "Relationship type: Friendships")
    static let relationshipUndefined = NSLocalizedString("Let's see", comment: "Relationship type: Undefined")
    static let relationshipDating = NSLocalizedString("Dating", comment: "Relationship type: Dating")
    static let relationshipLongTerm = NSLocalizedString("Long-Term Relationships", comment: "Relationship type: Long-Term Relationships")

    // sex enum
    static let hetero = NSLocalizedString("Heterosexual", comment: "Sexual orientation: Heterosexual")
    static let homoSexual = NSLocalizedString("Homosexual", comment: "Sexual orientation: Homosexual")
    static let biSexual = NSLocalizedString("Bisexual", comment: "Sexual orientation: Bisexual")
    static let panSexual = NSLocalizedString("Pansexual", comment: "Sexual orientation: Pansexual")
    static let asexual = NSLocalizedString("Asexual", comment: "Sexual orientation: Asexual")
    static let queer = NSLocalizedString("Queer", comment: "Sexual orientation: Queer")
    static let questioning = NSLocalizedString("Questioning", comment: "Sexual orientation: Questioning")
    static let intersex = NSLocalizedString("Intersex", comment: "Sexual orientation: Intersex")

    // smoker enum
    static let nonSmoker = NSLocalizedString("Non-Smoker", comment: "Smoking status: Non-Smoker")
    static let occasionalSmoker = NSLocalizedString("Occasional Smoker", comment: "Smoking status: Occasional Smoker")
    static let socialSmoker = NSLocalizedString("Social Smoker", comment: "Smoking status: Social Smoker")
    static let regularSmoker = NSLocalizedString("Regular Smoker", comment: "Smoking status: Regular Smoker")
    static let heavySmoker = NSLocalizedString("Heavy Smoker", comment: "Smoking status: Heavy Smoker")
    static let chainSmoker = NSLocalizedString("Chain Smoker", comment: "Smoking status: Chain Smoker")

    // app setting enum
    static let notification = NSLocalizedString("Notification", comment: "App setting: Notification")
    static let privacySecurity = NSLocalizedString("Privacy and security", comment: "App setting: Privacy and security")

    // authentification mode enum
    static let notRegisteredYet = NSLocalizedString("Not registered yet? Click here", comment: "Prompt for users not registered yet")
    static let alreadyRegistered = NSLocalizedString("Already have an account? Click here", comment: "Prompt for users already registered")

    // problem setting enum
    static let help = NSLocalizedString("Help", comment: "Problem setting: Help")
    static let aboutSoulDating = NSLocalizedString("About SoulDating", comment: "Problem setting: About SoulDating")


}
