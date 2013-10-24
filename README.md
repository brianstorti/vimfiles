Usage
========

Boost your productivity in four easy steps.

1. Clone the repo:
`git clone git://github.com/brianstorti/vimfiles.git ~/.vim`

2. Setup Vundle:
`git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle`

3. Make sure vim finds the vimrc file by symlinking it:
`echo "source ~/.vim/vimrc" >> ~/.vimrc`

4. Install the vim plugins
`vim -c BundleInstall`

Or you can just copy this line and you are good to go:
`git clone git://github.com/brianstorti/vimfiles.git ~/.vim && \
 git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle && \
 echo "source ~/.vim/vimrc" >> ~/.vimrc && \
 vim -c BundleInstall`
