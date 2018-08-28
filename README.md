# RWorkshop18

For non-authors:

The HTML for the course is at https://IRSAAtUMn.github.io/RWorkshop18/.

The PDF for the course is at
https://irsaatumn.github.io/RWorkshop18/RWorkshop18.pdf.

The example for the question about how to paste together many data frames
into one is in the folder [examples](examples).

For authors:

Post all workshop materials here.  

In order to collate the materials into a single git book, you can simply drop your Rmd files (and any supporting images, etc) OUTSIDE the docs folder.  Someone will put these into the book later.  Or, if you're comfortable with R bookdown, read the steps below.


1. In RStudio start a new project.  FILE / New Project > Version Control > Git.  In dialog box, paste the repository address: https://github.com/IRSAAtUMn/RWorkshop18.git and then click "Create Project" . 

2. Pull the current materials from github.     

3. Create an Rmd for your chapter of the book.  The file should be saved OUTSIDE the docs folder and start with a number that indicates its order in the book.  For example the first Intro to R chapter is named "01-IntroToR.Rmd".

4. "Build the book" by knitting the index file.   This will update the
   files in the "docs" folder of your project.

   In order to build both HTML and PDF you will need to install R package
   `webshot` which requires the system library `PhantomJS` (in addition,
   of course, to having R packages `knitr`, `rmarkdown`, and `bookdown`).
   The web page https://bookdown.org/yihui/bookdown/html-widgets.html suggests
   doing this with

       install.packages("webshot")
       webshot::install_phantomjs()

   one can also install PhantomJS in the preferred way for you operating
   system (on Ubuntu find PhantomJS in synaptic and install it).

5. Push changes to github.  It may take as long as 10 minutes for the
GitHub Pages to update so that the github.io site reflects the changes.
 
