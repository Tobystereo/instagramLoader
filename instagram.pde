// instagram.pde
//
// Reads an instagram user name and pulls the latest photo via JSON using
// the instagram API
// 
// http://www.tobystereo.com
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/**
 * changing colors and size by moving the mouse
 * 	 
 * MOUSE
 * position x          : size
 * position y          : color
 * 
 * KEYS
 * s                   : save png
 * p                   : save pdf
 */

import processing.pdf.*;
import org.json.*;

PImage latestInstagramPhoto;

boolean savePDF = false;



void setup() {
  size(500, 500);
  noCursor();
  
  latestInstagramPhoto = loadImage(getInstagramPhoto());
  
}


void draw() {
  // this line will start pdf export, if the variable savePDF was set to true 
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");

  colorMode(HSB, 360, 100, 100);
  rectMode(CENTER); 
  noStroke();
  
  image(latestInstagramPhoto,0,0,width,height);

  // end of pdf recording
  if (savePDF) {
    savePDF = false;
    endRecord();
  }
}


void keyPressed() {
  if (key=='s' || key=='S') saveFrame(timestamp()+"_##.png");
  if (key=='p' || key=='P') savePDF = true;
}


String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("$ty$tm$td_$tH$tM$tS", now);
}

String getInstagramPhoto() {
  String username = "tobystereo";
  String tobystereoFeed = "https://api.instagram.com/v1/users/self/feed?access_token=1574675.f59def8.43c935ee781a48ed9cc73d1aca9109c3";
  
  int theUserID = getUserID(username);
  String theImage = getLatestPhoto(theUserID);
  return theImage;
}

int getUserID(String username) {
  String findUserID = "https://api.instagram.com/v1/users/search?q=" + username + "&access_token=1574675.f59def8.43c935ee781a48ed9cc73d1aca9109c3";
  String request = findUserID;
  String response = loadStrings(request)[0];
  println("response: " + response);
  int theID = 0;
 
 // Make sure we got a response.
 if(response != null) {
   
   try {
     // Initialize the JSONObject for the response
     JSONObject root = new JSONObject(response);
     println("root: " + root);
     
     // Get the "data" JSONObject
     JSONArray theData = root.getJSONArray("data");
     println(theData);
     
     // Get the "id" value from the condition object
     JSONObject theDataObjects = theData.getJSONObject(0);
     
     theID = theDataObjects.getInt("id");
      
     // Print the temperature
     println("id = " + theID );
//     if(id != 0) {
//       theID = getlatestPhoto(id);
//     }
   }
   
   catch(JSONException e) {
     println("There was an error parsing the JSONObject."); 
   }
   
   
 }
 return theID;
}

String getLatestPhoto(int id) {
   String baseURL = "https://api.instagram.com/v1/users/";
  String accessToken = "access_token=1574675.f59def8.43c935ee781a48ed9cc73d1aca9109c3";
 String request = baseURL + id + "/media/recent?count=1&" + accessToken;
 String response = loadStrings(request)[0];
 println("Photoresponse: " + response);
 String theImage = "";
 
 // Make sure we got a response.
 if(response != null) {
   
   try {
     // Initialize the JSONObject for the response
     JSONObject root = new JSONObject(response);
     println("root: " + root);
     
     // Get the "data" JSONObject
     JSONArray theData = root.getJSONArray("data");
     JSONObject theDataObjects = theData.getJSONObject(0);
     println("theData: " + theData);
     
     // navigating through the JSON Array level by level
         JSONObject theImages = theDataObjects.getJSONObject("images");
         println("theImages: " + theImages);
         
           JSONObject theResolution = theImages.getJSONObject("standard_resolution");
           println("theResolution: " + theResolution);
             
             // read the target value into a variable
             theImage = theResolution.getString("url");
             println(theImage);
   }
   
   catch(JSONException e) {
     println(e.toString()); 
   }
 }
 return(theImage);
}
 
