// instagram.pde
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
import java.net.URL;
import java.net.URLConnection;

String baseURL = "https://api.instagram.com/v1/users/";
String accessToken = "access_token=1574675.f59def8.43c935ee781a48ed9cc73d1aca9109c3";

String instagramClientID = "87558987b6c64f97a821539f734d448e";
String instagramClientSecret = "a5a1fe147b2243faabd14f2ebd41c6ed";
String tobystereoFeed = "https://api.instagram.com/v1/users/self/feed?access_token=1574675.f59def8.43c935ee781a48ed9cc73d1aca9109c3";
String username = "tobystereo";
String findUserID = "https://api.instagram.com/v1/users/search?q=" + username + "&access_token=1574675.f59def8.43c935ee781a48ed9cc73d1aca9109c3";

boolean savePDF = false;
String theImageURL;
PImage instagramPhoto;

//int id;


void setup() {
  size(500, 500);
  noCursor();
  
  instagramPhoto = loadImage(getUsername());
  
}


void draw() {
  // this line will start pdf export, if the variable savePDF was set to true 
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");

  colorMode(HSB, 360, 100, 100);
  rectMode(CENTER); 
  noStroke();
  
  image(instagramPhoto,0,0,width,height);

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

String getUsername() {
 String request = findUserID;
 String response = loadStrings(request)[0];
 println("response: " + response);
 String theImage = "";
 
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
     
     int id = theDataObjects.getInt("id");
      
     // Print the temperature
     println("id = " + id );
     if(id != 0) {
       theImage = getlatestPhoto(id);
     }
   }
   
   catch(JSONException e) {
     println("There was an error parsing the JSONObject."); 
   }
   
   
 }
 return theImage;
}

String getlatestPhoto(int id) {
 String request = baseURL + id + "/media/recent?count=1&" + accessToken;
 String response = loadStrings(request)[0];
 println("Photoresponse: " + response);
 String theImage = "";
 
 // Make sure we got a response.
 if(response != null) {
   
   try {
     // Initialize the JSONObject for the response
     JSONObject root = new JSONObject(response);
//     JSONObject root = new JSONObject(join(loadStrings(response), ""));
     println("root: " + root);
     
     // Get the "data" JSONObject
     JSONArray theData = root.getJSONArray("data");
     println("theData: " + theData);
       JSONObject theDataObjects = theData.getJSONObject(0);
         JSONObject theImages = theDataObjects.getJSONObject("images");
          println("theImages: " + theImages);     
           JSONObject theResolution = theImages.getJSONObject("standard_resolution");
           println("theResolution: " + theResolution);
             theImage = theResolution.getString("url");
             println(theImage);
             
             
   }
   
   catch(JSONException e) {
     println(e.toString()); 
   }
 }
 return(theImage);
}
 

