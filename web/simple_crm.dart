library simple_crm;

import 'dart:html';
import 'dart:convert';

part '../model/simple_crm_entities.dart';

void main() {
  registerListeners();
  var id = "CRM";
  if (!window.localStorage.containsKey(id)) {
    fillWithFakeNames();
  }
  refreshContactList();
}

//Function which registers all the button listeners
void registerListeners(){
  query('#view-button').onClick.listen((e){
    toggleView(1);
  });
  
  query('#add-button').onClick.listen((e){
    toggleView(2);
  });
  
  query('#btnAdd').onClick.listen((e){
    addContact();
  });
}

// Switch between the two tables
void toggleView(int inMode){
  // List
  if (inMode == 1) {
    query('#contacts').classes.toggle('hidden');
    query('#add-contacts').classes.toggle('hidden');
  // Add
  } else if (inMode == 2) {
    query('#contacts').classes.toggle('hidden');
    query('#add-contacts').classes.toggle('hidden');
  }
}

// Function which removes a contact
bool removeContact(String inEmail){  
  String key = "CRM:${inEmail}";
  if (!window.localStorage.containsKey(key)) {
    displayErreur("Unable to delete ${inEmail}");
    return false;
  } else {
    try {
      String localKey = window.localStorage[key];
      window.localStorage.remove(key);
      displayConfirm('Contact removed.');
      refreshContactList();
      return true;
    } on Exception catch(e) {
      displayErreur("Please enable LocalStorage.");
      return false;
    } catch(e) {
      displayErreur(e.toString());
      return false;
    }
  }
}

// Function which edits a contact
bool editContact(String inOldEmail, String inName, String inEmail, String inPhone){
  if (inName == null || inName.isEmpty) {
    displayErreur("Cannot set empty name.");
    return false;
  }
  var exp = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  if (inEmail == null || inEmail.isEmpty) {
    displayErreur("Cannot set empty email.");
    return false;
  } else if (!exp.hasMatch(inEmail)) {
    displayErreur("Email format not valid.");
    return false;
  }
  exp = new RegExp(r"[0-9]{3}-[0-9]{3}-[0-9]{4}");
  if (inPhone == null || inPhone.isEmpty) {
    displayErreur("Cannot set empty phone.");
    return false;
  } else if (!exp.hasMatch(inPhone)) {
    displayErreur("Phone format not valid (XXX-XXX-XXXX).");
    return false;
  }
  Contact newContact = new Contact(inName, inEmail, inPhone);
  try {
    if (inOldEmail != inEmail) {
      removeContact(inOldEmail);
    }
    window.localStorage["CRM:${newContact.email}"] = newContact.toJSON();
    displayConfirm('Contact edited');
    refreshContactList();
    return true;
  } on Exception catch(e) {
    displayErreur("Please enable LocalStorage.");
    return false;
  } catch(e) {
    displayErreur(e.toString());
    return false;
  }
}

// Function which adds a contact
bool addContact(){
  InputElement inputName = document.query('#name');
  InputElement inputEmail = document.query('#email');
  InputElement inputPhone = document.query('#phone');
  if (inputName.value == null || inputName.value.isEmpty) {
    displayErreur("Cannot set empty name.");
    return false;
  }
  var exp = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  if (inputEmail.value == null || inputEmail.value.isEmpty) {
    displayErreur("Cannot set empty email.");
    return false;
  } else if (!exp.hasMatch(inputEmail.value)) {
    displayErreur("Email format not valid.");
    return false;
  }
  exp = new RegExp(r"[0-9]{3}-[0-9]{3}-[0-9]{4}");
  if (inputPhone.value == null || inputPhone.value.isEmpty) {
    displayErreur("Cannot set empty phone.");
    return false;
  } else if (!exp.hasMatch(inputPhone.value)) {
    displayErreur("Phone format not valid (XXX-XXX-XXXX).");
    return false;
  }
  Contact newContact = new Contact(inputName.value, inputEmail.value, inputPhone.value);
  try {
    window.localStorage["CRM:${newContact.email}"] = newContact.toJSON();
    displayConfirm('Contact added');
    refreshContactList();
    inputName.value = "";
    inputEmail.value = "";
    inputPhone.value = "";
    return true;
  } on Exception catch(e) {
    displayErreur("Please enable LocalStorage.");
    return false;
  } catch(e) {
    displayErreur(e.toString());
    return false;
  }
}

// Fill CRM with dumb names
void fillWithFakeNames(){
  Contact newContact = new Contact("John Smith", "john@smith.com", "555-111-2222");
  window.localStorage["CRM:${newContact.email}"] = newContact.toJSON();
  newContact = new Contact("Stephen Harper", "wannabe@gov.com", "555-222-5555");
  window.localStorage["CRM:${newContact.email}"] = newContact.toJSON();
  newContact = new Contact("Barack Obama", "godbless@america.com", "555-333-8888");
  window.localStorage["CRM:${newContact.email}"] = newContact.toJSON();
  displayErreur("");
}

// function to refresh the contact list
void refreshContactList(){
  query('#list-contacts').children.clear();
  int i = 0;

  for (String key in window.localStorage.keys) {
    if (key.toString().substring(0,3) == "CRM") {
      // Setup
      String strJSON = window.localStorage[key];
      Contact currentContact = new Contact.JSON(JSON.decode(strJSON));
      var htmlContact = '';
      
      // Build html
      htmlContact += '<div class="contact" id="contact${i}"><span class="icon" id="edit-ct${i}"><img src="img/pencil.png"></span><span class="icon" id="rem-ct${i}"><img src="img/cross.png"></span>';
      htmlContact += '<span class="name">${currentContact.name}</span>';
      htmlContact += '<span class="email">${currentContact.email}</span>';
      htmlContact += '<span>${currentContact.phone}</span>';
      htmlContact += '</div>';
      DivElement div = new Element.html(htmlContact);
      query('#list-contacts').children.add(div);
      htmlContact = '<div class="contact" id="hidcontact${i}"><span class="icon" id="save-ct${i}"><img src="img/accept.png"></span><span class="icon" id="can-ct${i}"><img src="img/cancel.png"></span>';
      htmlContact += '<span><input class="name" type="text" id="name${i}" placeholder="First Last" required value="${currentContact.name}"></input></span>';
      htmlContact += '<span><input class="email" type="email" id="email${i}" placeholder="you@web.com" required value="${currentContact.email}"></input></span>';
      htmlContact += '<span><input type="tel" id="phone${i}" placeholder="800-555-5555" required value="${currentContact.phone}"></input></span>';
      htmlContact += '</div>';
      div = new Element.html(htmlContact);
      query('#list-contacts').children.add(div);
      
      //Listeners
      query('#edit-ct${i}').onClick.listen((e){
        query('#contact${i}').classes.toggle('hidden');
        query('#hidcontact${i}').classes.toggle('hidden');
      });
      query('#rem-ct${i}').onClick.listen((e){
        if (removeContact(currentContact.email)){
          query('#contact${i}').classes.toggle('hidden');
          displayConfirm('${currentContact.name} removed');       
        }
      });
      query('#save-ct${i}').onClick.listen((e){
        InputElement inputName = document.query('#name${i}');
        InputElement inputEmail = document.query('#email${i}');
        InputElement inputPhone = document.query('#phone${i}');
        if (editContact(currentContact.email, inputName.value, inputEmail.value, inputPhone.value)) {
          query('#contact${i}').classes.toggle('hidden');
          query('#hidcontact${i}').classes.toggle('hidden');
          displayConfirm('${inputName.value} saved');
        }
      });
      query('#can-ct${i}').onClick.listen((e){
        query('#contact${i}').classes.toggle('hidden');
        query('#hidcontact${i}').classes.toggle('hidden');
      });
      //Count
      i++;
    }
  }
}

// Error helper
void displayErreur(String inMessage){
  query('#error').innerHtml = inMessage;
  query('#confirm').innerHtml = '';
}

// Confirm helper
void displayConfirm(String inMessage){
  query('#confirm').innerHtml = inMessage;
  query('#error').innerHtml = '';
}
