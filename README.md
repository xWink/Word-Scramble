# Ada Word Scrambler
#### A scrambler that you can still read from

## How to Use wordscram.adb:

1. Compile with `gnatmake wordscram.adb`
2. Run with `./wordscram`
3. Input a filename containing text you want to scramble
5. Program will read the file and output the number of words in the file followed by the contents such that each word is scrambled, excluding the first and last letters and any punctuation.

#### Note: The original file is not modified.

## Example:
File content: 
```
There are seven elephants in the house.
```

Output:
```
Trhee are sveen etnalehps in the huose.

Number of words: 7
```
