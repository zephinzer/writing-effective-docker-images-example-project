# Writing Docker Files Example Project

This repository contains the example code used in the article "Writing effective Docker Images more efficiently" which can be found at: https://blog.gds-gov.tech/writing-effective-docker-images-more-efficiently-bf0129c3293b.

# Slides

This example repository comes with a set of slides for use in presentations. See the `.presentation` directory for more info.

## Local Installation
```
yarn install
```

## Running the Presentation

An `npm` script has been setup, use the following to start the slides:

```
npm run slideshow
```

Or call it yourself using `reveal-md`:

```
reveal-md --css ./.presentation/style.css -w ./.presentation/slides.md
```

## Licensing

Slides are licensed under the Creative Commons Attribution-NonCommercial 3.0 Singapore License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/3.0/sg/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

Feel free to share it around and use it for your own presentations! For attribution matters, copy and paste the following into your own works under a visible attribution space if you're using/remixing it:

> Adapted from @zephinzer's slides on Writing Effective Docker Images More Efficiently and the original content can be found at the GitHub repository located at: https://github.com/zephinzer/writing-effective-docker-images-example-project. 
