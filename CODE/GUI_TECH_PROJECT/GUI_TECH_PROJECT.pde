import controlP5.*;
import processing.serial.*;
import java.util.*;

//Serial variables
Serial myPort;    // The serial port
PFont myFont;     // The display font
String inString;  // Input string from serial port
int lf = 10;      // ASCII linefeed 

//CP5 object constructors called for graphical purposes
ControlP5 cp5;
ControlP5 cp6;
ControlP5 cp7; 

//DropDownLists declarations
DropdownList ddl1, ddl2;

//Image to set the background
PImage bg;

//Students database with UID stored 
Map <String, String> dataBase = new HashMap<String, String>();

//Stored list of student's names to display in GUI
ArrayList<String> studentList = new ArrayList<String>(); 

//Students how are actually here after serial event 
Map <String, String> here = new HashMap<String, String>();

//Store number of absent students
int absent = 0;  

//Array with student who are here
ArrayList<String> studentHereList = new ArrayList<String>();

//This function reads class.txt and store values in data base
ArrayList<String> initDataBase()
{
  String[] lines = loadStrings("class.txt");    
  println("there are " + lines.length + " lines");

  for (int i = 0 ; i < lines.length; i++)
  { 
      String[] list = split(lines[i], ':');
      
      //We just add the names so they can be display in the UI
      studentList.add(list[1]);
      
      //list[0] is the key list[1] is the value
      dataBase.put(list[0],list[1]);
      
  }
  
  System.out.println("Initial Mappings are: " + dataBase); 
  return studentList; 
}

void setDropDownList()
{
  
  
  ddl1 = cp5.addDropdownList("DATA BASE")
            .setPosition(80, height/4)
            .setSize(400,800)
            .setBarHeight(40)
            .setItemHeight(40)
            .addItems(studentList)
            .setType(ScrollableList.DROPDOWN)
            //.setOpen(false) //false for closed
            ;
}

void setDropDownAttendance()
{
  ddl2 = cp5.addDropdownList("ATTENDANCE")
            .setPosition(1120-400, height/4)
            .setSize(400,800)
            .setBarHeight(40)
            .setItemHeight(40)
            .setType(ScrollableList.DROPDOWN)
            //.setOpen(false) //false for closed
            ;
}
void readSerialPort()
{
  printArray(Serial.list()); 
  myPort = new Serial(this, Serial.list()[0], 9600); 
  myPort.bufferUntil(lf); //Bufferise until carriage return before sending
}

// We handle the serial event to manage sudents 
void serialEvent(Serial p) { 
  inString = p.readString();
   PrintWriter output;
   //We write UID in present.txt
   output = createWriter("present.txt");
   output.print(inString);
   
   //We make sure all data is printed
   output.flush();
   
   //Closing output
   output.close();
   
   
   String[] lines = loadStrings("present.txt");
   System.out.println(lines[0]);
   System.out.println(dataBase.get(lines[0]));
   
   //If student doesn't exist in data base or already tagged 
   //We add him on every present lists of data 
   if(here.get(lines[0])==null && dataBase.get(lines[0])!= null)
   {
       here.put(lines[0], dataBase.get(lines[0]));
       studentHereList.add(here.get(lines[0]));
       absent =dataBase.size()-here.size();
       sendNameToSerial(here.get(lines[0])); 
       updateGUI(); 
   }
   System.out.println(here.toString());
}

void updateGUI()
{
  //we clear ddl2 items not have the same student twice
  ddl2.clear(); 
  ddl2.addItems(studentHereList);
  
}

void setDashBoardTitle(String string)
{
  textAlign(CENTER);
  textSize(40); 
  text(string,(width/2), 50);
}

void sendNameToSerial(String string)
{
  String[] name = split(string, " "); 
  myPort.write(name[0]);
  myPort.write(name[1]); 
  System.out.println(name[0]); 
  System.out.println(name[1]);
}

/*******SETUP******/
void setup() 
{
  size(1200, 800);
  surface.setTitle("Attendance system");
  // The background image must be the same size as the parameters
  bg = loadImage("bg.png");
  
  //Creating 2 controlP5 objects 
  cp5 = new ControlP5(this);
  cp6 = new ControlP5(this); 
  cp7 = new ControlP5(this); 
  
  //Creating the two drop down lists 
  //and initialising their values 
  studentList = initDataBase(); 
  setDropDownList();
  setDropDownAttendance();
  readSerialPort();
  
  //We do a first absent setting
  absent =dataBase.size()-here.size();
}

/*****DRAW********/          
void draw()
{
  //Displaying background
  background(bg);
  //Title 
  setDashBoardTitle("DASHBOARD");
  
  //Asent number display
  text("Absents : ",100,30);
  text(Integer.toString(absent), 200, 30);
}
