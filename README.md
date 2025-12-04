# invertober2025: phylogenetic wrap-up

In this repository you will find codes and data used to generate the ML phylogenetic inference of the species included in the **invertober2025 initiative**.

<img src="figures\final_tree_panel.png" alt="invertober tree">

Scroll down for a full description of the image.

## What is invertober?
In its creator's own words, <a href="https://www.instagram.com/fossil.forager/" target="blank">@fossil.forager</a>, invertober is "**an <a href="figures\invertober_list.jpg" target="blank">art prompt list</a> celebrating the biodiversity of invertebrates throughout the month of October**! The goal is to encourage the creation of invertebrate themed art and have fun!"

## Why all this?
This was my first invertober ever. I've always been fascinated by the astonishing diversity of invertebrates, and—as it happens that I also like drawing them—I decided to embark.

Of course, I couldn't participate just by drawing every now and then few prompts. No... I had to make *all* of them day by day (with a few delays towards the end).

As I wrote in <a href="https://bsky.app/profile/filonico.bsky.social/post/3m5oucax5322f" target="blank">my last invertober2025 post on BlueSky</a>, at the end of it I felt excited + in pain + rewarded + exhausted. But at least it was worth it!

Ok, cool. But still: **why all of this? Why the phylogenetic tree, the plots, and everthing?**

Well, I was looking for a way to wrap my invertober2025 up. I could've gone for a collage maybe. But I'm not an artist by training, and I feel I don't have an eye for this kind of composition. Then I realized that I am an evolutionary biologist and **I love phylogenetic trees**! I had got the answer: my invertober2025 wrap up would've been a maximum likelihood (ML) phylogenetic tree!

So I started gathering genomic data for the prompt species (or their closest relatives if they had not been sequenced yet) and setting up the working directory. Then followed a simple <a href="https://busco.ezlab.org/" target="blank"><code>BUSCO</code></a> run to extract conserved genes, and eventually the ML inference with my pipeline <a href="https://github.com/filonico/phySCO"><code>phySCO</code></a>. And there we go!

But afterwards, I also realized that I was having in my hands a full phylogenetic dataset that I could've analysed further: what were the proportions of each taxonomic groups in it? How complete was the gene matrix? And how easy would it have been to have a time-calibrated tree? I couldn't stop...

**That's how I ended up doing this: just by chance**. Now I feel that I may be using this dataset in the future to test further codes, softwares or coding styles... who knows. For the moment, enjoy it as the wrap-up of my invertober2025!

## Full descriptions of figures
<img src="figures\final_tree.png" alt="invertober tree">
The image above is a ML phylogenetic tree as easy as it can be. Just a plain topology, with branch lengths proportional to the degree of genetic change between two nodes. Bootstrap supports are maximum (100) for every node, except were noted.

**Represented phyla** are coded by colors and indicated by a text label next to their node (when possible).

At tips, species names as indicated in the invertober2025 prompt are reported. Note that for some species the genome was not available (at least on NCBI, the only repository that I checked). In those cases I decided to rely on a closely related taxon. Specifically, if you find an asterisk ('<code>\*</code>') next to the tip name, it means that I used a genome from a species in the same genus. Conversely, if you find two asterisks ('<code>\*\*</code>'), it means that I used a genome from a species in a different genus.

The dataset that I used for the phylogenetic analysis can be accessed in <a href="00_input\dataset.tsv" target="blank"><code>00_input/dataset.tsv</code></a>
