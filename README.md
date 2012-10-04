Usage
========

**First, make sure you've a backup of your old configurations before proceeding.**  

#####Clone the repo:   
```git clone git://github.com/brianstorti/vimfiles.git ~/.vim```  

#####Grab the plugin submodules:  
```cd ~/.vim && git submodule init && git submodule update```  

#####Make sure vim finds the vimrc file by either symlinking it:   
```ln -s ~/.vim/vimrc ~/.vimrc```  

#####or by sourcing it from your own ~/.vimrc:   
```source ~/.vim/vimrc```

Dependencies
========
You will need these dependencies figured out:  
- Ruby (for the Command-T plugin)
- Exuberant Ctags (http://ctags.sourceforge.net/)  

In OS X, you can install ctags with homebrew:  
```brew install ctags```