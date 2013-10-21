part of simple_crm;

class Contact {
  String _name;
  String _email;
  String _phone;
  
  Contact(name, email, phone) {
    this.name = name;
    this.email = email;
    this.phone = phone;
  }
  
  Contact.JSON(Map inJSONMap) {
    this.name = inJSONMap["name"];
    this.email = inJSONMap["email"];
    this.phone = inJSONMap["phone"];
  }

  String get name => _name;
  void set name(value) {
    if (value == null || value.isEmpty) {
      throw new ArgumentError("Cannot set empty name.");
    } else {
      _name = value;
    }
  }

  String get email => _email;
  void set email(value) {
    // http://stackoverflow.com/questions/16800540/validate-email-address-in-dart
    var exp = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (value == null || value.isEmpty) {
      throw new ArgumentError("Cannot set empty email.");
    } else if (exp.hasMatch(value)) {
      _email = value;
    } else {
      throw new ArgumentError("Email format not valid.");
    }
  }

  String get phone => _phone;
  void set phone(value) {
    var exp = new RegExp(r"[0-9]{3}-[0-9]{3}-[0-9]{4}");
    if (value == null || value.isEmpty) {
      throw new ArgumentError("Cannot set empty phone.");
    } else if (exp.hasMatch(value)) {
      _phone = value;
    } else {
      throw new ArgumentError("Phone format not valid (XXX-XXX-XXXX).");
    }
  }
  
  String toJSON() {
    var MapContact = new Map<String, Object>();
    MapContact["name"] = name;
    MapContact["email"] = email;
    MapContact["phone"] = phone;
    return JSON.encode(MapContact);
  }

  void fromJSON(Map JSONString) {
    this.name = JSONString["name"];
    this.phone = JSONString["phone"];
    this.email = JSONString["email"];
  }
}