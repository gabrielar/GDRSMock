GDRSMock 
========

GDRSMock is a light weight Objective-C implementation of mock objects. I have
written GADRSMock because I found OCMock's implementation to be over-engineered.
GDRSMock simply stands-in the real object (mocked object) and let's the messages
on behalf of the real object.


Installation
-----------

The GDRSMock has a library target. Hence all that needs to be done is to copy
the contents of the GDRSMock library into your project directory, and add the
GDRSMock to your project. Then the test target in your project need to be made
dependent on the lib target from the GDRSMock project. Also make sure that the
header and library search paths of your project include '$(BUILT_PRODUCTS_DIR)'.

Step by step instructions:

1.	Copy the contents of the GDRSMock repository into your project directory, it
	does not matter where exactly. 
1.	Open your project in XCode. 
1.	In XCode (with your project open) select the group which you wish to contain
	the GDRSMock project, and bring up it's context menu. 
1.	In the context menu select 'Add files to "<< your project name >>"...' 
1.	Select the GDRSMock project file (ie. GDRSMock.xcodeproj), and click the 'Add'
	button. 
1.	Go to the 'Build Phases' of your project, and select the tests target.
1.	Add the GDRSMock library to the 'Target Dependencies'.
1.	Go to the 'Build Settings' of your project, and select the tests target.
1.	Add '$(BUILT_PRODUCTS_DIR)' to the 'Header Search Path' and to the 'Library Search Path'.



