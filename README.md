# ChattingAppDemo
This project is to show how I deal with the appearance of a normal chatting app, 
all pictures and conversations are saved to UserDefault.

### How to draw chat bubble programmatically:
see ⁨ChattingAppDemo⁩/⁨chat⁩/⁨main⁩/⁨views⁩/BubbleCollectionViewCell.swift and BubbleCollectionViewCell.xib

I use autolayout in the xib file and override the function "preferredLayoutAttributesFitting",
to dynamically decide the size of a collectionView cell.
Then, I draw a chat bubble using CAShapeLayer, and apply it to the sized cell.

### How to make fancy transition animation:
see files in ⁨ChattingAppDemo⁩/⁨chat⁩/DisplayPictures

OverviewPicturesViewController and PictureDetailViewController are used to define the UI of a simple picture viewer.
They both have a BubbleCollectionViewDelegate, to share the information of their visible pictures, such as position, size,
which are needed to make animated transition when presenting and dismissing picture viewer.


![demo](https://github.com/vanessashe/ChattingAppDemo/raw/master/MyImages/demo.mp4)
