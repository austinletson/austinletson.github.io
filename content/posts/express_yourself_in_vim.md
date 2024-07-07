---
title: "Express Yourself! The Power of Regular Expressions in Vim"
date: 2020-04-29T14:09:05-04:00
tags : [
    "editors",
    "vim",
    "regular-expressions",
    "jane-austen",
]
categories : [
    "editors",
]
---

Sometimes we know what we want to do with text even if we don't
know what the text is.

Regular expressions are an important feature of many tools (programing
languages, command line tools, etc.), but they play an especially important
role in Vim. Text in Vim is first class, so all of Vim's features should
ultimately serve the purpose of editing text. Here we will explore some
examples where regular expressions serve Vim well in this effort. 


## Sorting 
Vim's built in [sort](https://vim.fandom.com/wiki/Sort_lines) function is
a very powerful tool to sort lines. Let's say we have a file with the
following grocery list. 

> Blueberries-Frozen (Trader Joes)   
> Charcoal (Trader Joes)   
> Cookies-Bakery (Whole Foods)   
> Ice (Trader Joes)  
> Lettuce-Produce (Whole Foods)   
> Peaches-Produce (Trader Joes)   
> Salmon-Fish (Fresh Market)   
> Strawberries-Frozen (Whole Foods)   
> Trout-Fish (Fresh Market)   
> Waffles-Frozen (Whole Foods)   

The list features items from multiple sections at different grocery
stores.  We want to optimize our time shopping, since we have important
Vim related research to take care of, so we need to sort our list
beforehand. Using the **:sort** command alone would sort the entries
alphabetically by item name. This isn't useful as no grocery store is laid
out in a such a fashion. However using the **r** option we can feed sort
a regular expression which identifies which section of the line to sort
on. 

First we sort the list based on category with the following command

```
:sort /-\w*/ r
```
> Charcoal (Trader Joes)   
> Ice (Trader Joes)  
> Cookies-**Bakery**(Whole Foods)   
> Salmon-**Fish** (Fresh Market)   
> Trout-**Fish** (Fresh Market)   
> Blueberries-**Frozen** (Trader Joes)   
> Strawberries-**Frozen** (Whole Foods)   
> Waffles-**Frozen** (Whole Foods)   
> Peaches-**Produce** (Trader Joes)   
> Lettuce-**Produce** (Whole Foods)   

Here we match on the on the word following a hyphen and our list
is sorted! But this list is still of little use since the items are distributed
across three grocery stores. The following command can help us out.

```
:sort /(.*)/ r
```
> Salmon-Fish **(Fresh Market)**   
> Trout-Fish **(Fresh Market)**   
> Ice **(Trader Joes)**  
> Charcoal **(Trader Joes)**   
> Blueberries-Frozen **(Trader Joes)**   
> Peaches-Produce **(Trader Joes)**   
> Cookies-Bakery **(Whole Foods)**   
> Strawberries-Frozen **(Whole Foods)**   
> Waffles-Frozen **(Whole Foods)**   
> Lettuce-Produce **(Whole Foods)**   

In a similar stroke, we match on the text in parenthesis and now the list
is sorted first by grocery store and second by section!

## Repeated words

When writing prose, repeated words are almost always a typo (save the
occasional *that that*). Below I have taken us back to the early
nineteenth century where an eager Jane Austen has just written the first
line of *Pride and Prejudice* and has erroneously repeated two words.

>It is a **truth truth** universally acknowledged, that a single man in
>possession of a **good good** fortune must be in want of a wife.

Now after completing this timeless sentence, Ms. Austen starts a search in
Vim and with the following regular expression matches the repeated words.
dockhad
```
\<\(\w\+\) \1\>
```
Here she uses a capture group and a backreference to identify repeated
words and quickly with a substitution...
```
%s/\<\(\w\+\) \1\>/\1/g
```
> It is a **truth** universally acknowledged, that a single man in possession of a **good** fortune must be in want of a wife.

she can correct her mistake.

It is also possible to use Vim's unique lookahead syntax (\@=) to find
words that appear within a given distance of another, or in this case of
themselves. Here is an example in the opening lines of *All the Pretty
Horses*. 

```
\<\(\w\+\)\>\(.\{0,50}\<\1\>\)\@=
```
> The **candleflame** and the image of the candleflame caught in the
> pierglass and twisted and righted when he entered the hall and again
> when he shut the door.

Here our expression starts the same with a capture group containing
a word, but instead of following with a direct reference to our first
capture group, we embed our reference within a second capture group along
with an arbitrarily quantified set of any character. Here we use fifty. In
Vim we include **\@=** at the end of a capture group to signify
a lookahead. 

Unlike the first case this by no means indicates a typo and as in the
sentence above, it is often to great affect. 

As an aside, 'and' and 'the' are also found by this pattern in the above
example. I think any reasonable implimentation of this feature would
exclude articles and the like.

## Vim Rocks
In closing, Vim rocks. And regular expressions rock. So they go great
together.

