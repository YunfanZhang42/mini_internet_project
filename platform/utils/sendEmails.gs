function sendEmails() {
  var sheet = SpreadsheetApp.getActiveSheet();
  var data = sheet.getDataRange().getValues();

  // AS information
  var asnumcolidx = data[0].indexOf("as");
  var passwordcolidx = data[0].indexOf("password");

  // student information
  var unicolidx = data[0].indexOf("uni");
  var nameidx = data[0].indexOf("name");
  var taidx = data[0].indexOf("ta");


  // Credential email
  /*
  var subject = "CSEE4119-Project 2: Credentials for BYOI Project";
  var credRange = sheet.getRange(11, 1, 82, 7);
  var credData = credRange.getValues();


  for (i in credData) {
    var row = credData[i];
    var uni = row[unicolidx];
    var studentname = row[nameidx];

    if (studentname == "TA") {
      continue;
    }

    var email = uni + "@columbia.edu";
    var asnum = row[asnumcolidx];
    var password = row[passwordcolidx];

    var greetingmsg = "Dear " + studentname + ","
    var intromsg = "Your credentials for accessing the Build Your Own Internet (BYOI) platform are below.";
    var credentialmsg = "Name: " + studentname + "\n\n" + "Internet IP: 34.72.133.64\n" + "AS Number: " + asnum + '\n' + "SSH Username: " + "root" + '\n' + "SSH Password: " + password + "\n\n";
    var signingoffmsg = "The project document, along with further details on usage of the above credentials will be released soon. \n\nBest of luck!"

    var msg = greetingmsg + '\n\n' + intromsg + '\n\n' + credentialmsg + signingoffmsg;
    Logger.log("Email address: " + email + "\nSubject: " + subject + "\nMessage:\n" + msg + '\n');
    MailApp.sendEmail(email, subject, msg);
    // break
  }
  */

  // Preliminary Stage Bulk Emails- correct config
  /*
  var subject = "CSEE4119-Project 2: Preliminary Stage Results- 11/24/2020"
  var credRange = sheet.getRange(1, 1, 82, 4);
  var credData = credRange.getValues();
  x =   for (i in credData) {
    var row = credData[i];
    var uni = row[unicolidx];
    var studentname = row[nameidx];
    var asnum = row[asnumcolidx];

    if (studentname == "TA") {
      continue;
    }

    if (asnum == "3" || asnum == "5" || asnum == "9" || asnum == "43" || asnum == "47" || asnum == "69" || asnum == "88" || asnum == "110" || asnum == "124" || asnum == "166" || asnum == "186" || asnum == "126" || asnum == "169" || asnum == "23" || asnum == "148" ) {
      continue
    }

    var email = uni + "@columbia.edu";
    var asnum = row[asnumcolidx];

    var greetingmsg = "Dear " + studentname + ","
    var intromsg = "Your results for the preliminary stage are as below:";
    var statusmsg = "Name: " + studentname + "\n\n" + "AS Number: " + asnum + '\n' + "Status: Configuration successful. No further action is required.";

    var msg = greetingmsg + '\n\n' + intromsg + '\n\n' + statusmsg;
    Logger.log("Email address: " + email + "\nSubject: " + subject + "\nMessage:\n" + msg + '\n');
    MailApp.sendEmail(email, subject, msg);
    // break
  }
  */

  // Preliminary Stage Bulk Emails- no advertisment
  /*
  var subject = "CSEE4119-Project 2: Preliminary Stage Results- 11/24/2020"
  var credRange = sheet.getRange(1, 1, 82, 4);
  var credData = credRange.getValues();
  for (i in credData) {
    var row = credData[i];
    var uni = row[unicolidx];
    var studentname = row[nameidx];
    var asnum = row[asnumcolidx];

    if (studentname == "TA") {
      continue;
    }

    var email = uni + "@columbia.edu";

    if (asnum == "5" || asnum == "9" || asnum == "43" || asnum == "69" || asnum == "88" || asnum == "124" || asnum == "166" || asnum == "186" ){
      var greetingmsg = "Dear " + studentname + ","
      var intromsg = "Your results for the preliminary stage are as below:";
      var statusmsg = "Name: " + studentname + "\n\n" + "AS Number: " + asnum + '\n' + "Status: Incorrect configuration- no prefix advertised.";
      var extradurationmsg = "The next evaluation will be at 11pm EST, 11/25/2020. Please make sure you have the correct configuration by then."

      var msg = greetingmsg + '\n\n' + intromsg + '\n\n' + statusmsg + '\n\n'+ extradurationmsg;
      Logger.log("Email address: " + email + "\nSubject: " + subject + "\nMessage:\n" + msg + '\n');
      MailApp.sendEmail(email, subject, msg);
    }
  }
  */
}