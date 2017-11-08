# Running these slides

You'll need to install `reveal-md` to use this set of slides:

## Global Installation
```
npm install -g reveal-md
```

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