#!/bin/env Rscript

library(tidyverse)

setwd("/DATABIG/filipponicolini/invertober2025")


#####################
#     LOAD DATA     #
#####################

species_per_class <- read.table("04_plots/01_inputs/species_per_class.tsv", header = TRUE)
species_per_class

dataset <- read.table("00_input/dataset.tsv", header = TRUE)
dataset

gene_per_genomes <- read.table("04_plots/01_inputs/gene_per_genomes.tsv", header = FALSE) %>%
  rename("gene" = "V1", "genome" = "V2")
gene_per_genomes

tot_invertober <- sum(species_per_class$species_invertober)
tot_described <- 1834180 # CoL, accessed 15/11/2025


##########################################
#     BARPLOT OF TAXA REPRESENTATION     #
##########################################

barplot <- species_per_class %>%
  mutate(species_invertober_ratio = species_invertober/tot_invertober*100,
         species_described_ratio = species_described_15112025/tot_described*100) %>%
  select(-c(species_invertober, species_described_15112025)) %>%
  filter(class != "Not_assigned") %>%
  pivot_longer(-class, names_to =  "ratio") %>%
  
  ggplot(aes(y = class, x = value, fill = ratio)) +
  # geom_col(col = "black", position = "dodge", linewidth = 0.6) +
  geom_col(position = "dodge") +
  
  scale_fill_manual(values = c("#004488", "#DDAA33"),
                    labels = c("Within Metazoa",
                               "Within invertober2025")) +
  
  scale_x_continuous(limits = c(0, 81),
                     breaks = seq(0, 100, 20)) +
  scale_y_discrete(limits = rev) +
  
  labs(title = "Fraction of species per class",
       y = "Class", x = "% of species", fill = "") +
  
  theme_bw(base_size = 12) %+replace%
  theme(plot.background = element_rect(fill = "transparent", colour = NA), 
        panel.background = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_line(color = "grey90", lineend = "round"),
        panel.border = element_blank(),
        legend.background = element_rect(fill = "transparent", colour = NA),
        legend.key = element_rect(fill = "transparent", colour = NA),
        legend.key.width = unit(0.4, "cm"),
        legend.key.height = unit(0.4, "cm"),
        legend.position = "bottom",
        plot.title = element_text(size = 13, hjust = 0.0, vjust = 1.75, face = "bold"),
        axis.line = element_line(color = "black", linewidth = 0.6, lineend = "round"),
        axis.ticks = element_line(colour = "black", linewidth = 0.6, lineend = "round"),
        axis.ticks.length = unit(0.20, "cm"),
        axis.text.y = element_text(color = "black", hjust = 1, #vjust = 1,
                                   margin = margin(t = 0, r = 4, b = 0, l = 0)),
        axis.text.x = element_text(color = "black",
                                   margin = margin(t = 4, r = 0, b = 0, l = 0)),
        axis.title.x = element_text(size = 13, angle = 0,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.title.y = element_text(size = 13, angle = 90,
                                    margin = margin(t = 10, r = 0, b = 0, l = 0)))
barplot

ggsave("04_plots/barplot_fraction_species.pdf",
       barplot, device = cairo_pdf,
       width = 5.5, height = 5, units = "in", dpi = 300, bg = "white")


#################################
#     GENE OCCUPANCY MATRIX     #
#################################

tileplot <- gene_per_genomes %>%
  mutate(gene = factor(gene),
         gene_index = as.numeric(gene)) %>%
  left_join(dataset, by = join_by("genome" == "genome_used")) %>%
  mutate(genome = factor(genome, level = c("GCF_000188695.1", "GCF_000002865.3", "GCA_964019055.1", "GCA_014526335.2", "GCF_038396675.1",
                                           "GCA_037976565.1", "GCA_965235105.1", "GCA_964340945.1", "GCA_949752735.1", "GCF_001194135.2",
                                           "GCA_037127315.1", "GCA_029582155.1", "GCA_037379345.1", "GCA_012295275.1", "GCA_032362205.1",
                                           "GCA_034508935.3", "GCF_043290135.1", "GCA_907164885.2", "GCA_949358305.1", "GCA_032361705.1",
                                           "GCA_023014485.1", "GCA_000376725.2", "GCF_021130785.1", "GCA_965247725.1", "GCF_003227725.1",
                                           "GCA_020423425.1", "GCA_002278615.1", "GCF_030347505.1", "GCF_036711975.1", "GCA_951509405.1",
                                           "GCA_029030555.1", "GCA_964340655.1", "GCA_905147815.2"))) %>%
  # drop_na() %>%
  ggplot(aes(x = gene_index, y = genome, fill = phylum)) +
  geom_tile() +
  
  scale_fill_manual(values = c("#E69F00", "#56B4E9", "#009E73", "#0072B2", "#D55E00", "#CC79A7", "#999999"),
                    labels = c("Annelida", "Arthropoda", "Cnidaria", "Echinodermata", "Mollusca", "Platyhelminthes", "Outgroup")) +
  
  scale_y_discrete(limits = rev) +
  scale_x_continuous(expand = c(0, 0), breaks = c(1, seq(25, 100, 25))) +
  
  labs(title = "Gene occupancy table",
       x = "BUSCO genes", y = "Genomes") +
  
  theme_bw(base_size = 12) %+replace%
  theme(plot.background = element_rect(fill = "transparent", colour = NA),
        panel.background = element_blank(),
        panel.grid = element_blank(),
        panel.border = element_blank(),
        legend.background = element_rect(fill = "transparent", colour = NA),
        legend.key = element_rect(fill = "transparent", colour = NA),
        legend.key.width = unit(0.4, "cm"),
        legend.key.height = unit(0.4, "cm"),
        legend.position = "none",
        plot.title = element_text(size = 13, hjust = 0.0, vjust = 1.75, face = "bold"),
        axis.line = element_blank(),
        axis.ticks = element_blank(),
        # axis.ticks.length = unit(0.20, "cm"),
        axis.text.y = element_text(color = "black", size = 7,
                                   margin = margin(t = 0, r = 4, b = 0, l = 0)),
        axis.text.x = element_text(color = "black",
                                   margin = margin(t = 0, r = 4, b = 0, l = 0)),
        axis.title.y = element_text(angle = 90, size = 13,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.title.x = element_text(angle = 0, size = 13,
                                    margin = margin(t = 10, r = 0, b = 0, l = 0)))
tileplot

ggsave("04_plots/tileplot_completeness_matrix.pdf",
       tileplot, device = cairo_pdf,
       width = 5.5, height = 5, units = "in", dpi = 300, bg = "white")


##############################################
#     SCATTER DIFFICULTY VS SATISFACTION     #
##############################################

scatter_complete <- dataset %>%
  drop_na() %>%
  ggplot(aes(x = difficulty_level, y = satisfaction_level)) +
  geom_smooth(method = "lm", col = "black", fill = "grey85", linewidth = 0.6) +
  
  
  ggrepel::geom_text_repel(aes(label = ifelse(sp_ID == "Sspa",
                                              as.character("Bobbit"), "")),
                           position = position_jitter(seed = 1),
                           min.segment.length = 0, segment.size  = 0.2,
                           size = 4, box.padding = 1.2, seed = 1) +
  
  ggrepel::geom_text_repel(aes(label = ifelse(sp_ID == "Rfer",
                                              as.character("Palmetto"), "")),
                           position = position_jitter(seed = 1),
                           min.segment.length = 0, segment.size  = 0.2,
                           size = 4, box.padding = 1.2, seed = 1) +
  
  ggrepel::geom_text_repel(aes(label = ifelse(sp_ID == "Lful",
                                              as.character("Dragonfly"), "")),
                           position = position_jitter(seed = 1),
                           min.segment.length = 0, segment.size  = 0.2,
                           size = 4, box.padding = 1.2, seed = 10) +
  
  geom_jitter(aes(col = phylum), size = 2.5,
              position = position_jitter(seed = 1)) +
  
  ggpubr::stat_cor(method = "pearson", size = 4,
                   label.x.npc = "left", label.y.npc = "bottom") +
  
  scale_x_continuous(limits = c(19,101), breaks = seq(0, 100, 25)) +
  scale_y_continuous(limits = c(19,101), breaks = seq(0, 100, 25)) +
  
  scale_color_manual(values = c("#E69F00", "#56B4E9", "#009E73", "#0072B2", "#D55E00", "#CC79A7", "#999999"),
                     labels = c("Annelida", "Arthropoda", "Cnidaria", "Echinodermata", "Mollusca", "Platyhelminthes", "Outgroup")) +
  
  labs(title = "Difficulty vs Satisfaction",
       x = "Difficulty level",
       y = "Satisfaction level",
       col = "") +
  
  theme_bw(base_size = 12) %+replace%
  theme(aspect.ratio = 1,
        plot.background = element_rect(fill = "transparent", colour = NA), 
        panel.background = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_line(color = "grey90", lineend = "round"),
        panel.border = element_blank(),
        legend.background = element_rect(fill = "transparent", colour = NA),
        legend.key = element_rect(fill = "transparent", colour = NA),
        legend.key.width = unit(0.4, "cm"),
        legend.key.height = unit(0.4, "cm"),
        legend.position = "bottom",
        plot.title = element_text(size = 13, hjust = 0.0, vjust = 1.75, face = "bold"),
        axis.line = element_line(color = "black", linewidth = 0.6, lineend = "round"),
        axis.ticks = element_line(colour = "black", linewidth = 0.6, lineend = "round"),
        axis.ticks.length = unit(0.20, "cm"),
        axis.text.x = element_text(color = "black",
                                   margin = margin(t = 4, r = 0, b = 0, l = 0)),
        axis.text.y = element_text(color = "black",
                                   margin = margin(t = 0, r = 4, b = 0, l = 0)),
        axis.title.y = element_text(angle = 90, size = 13,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.title.x = element_text(angle = 0, size = 13,
                                    margin = margin(t = 10, r = 0, b = 0, l = 0)))
scatter_complete

ggsave("04_plots/scatter_difficultyVSsatisfaction.pdf",
       scatter_complete, device = cairo_pdf,
       width = 5, height = 5.5, units = "in", dpi = 300, bg = "white")

dataset %>%
  drop_na() %>%
  filter(sp_ID != "Sspa",
         sp_ID != "Lful",
         sp_ID != "Rfer") %>%
  
  ggplot(aes(x = difficulty_level, y = satisfaction_level)) +
  geom_smooth(col = "black", method = "lm") +
  
  geom_jitter(aes(col = class), size = 2.5,
              position = position_jitter(seed = 1)) +
  
  ggpubr::stat_cor(method = "pearson", size = 3,
                   label.x.npc = "left", label.y.npc = "bottom") +
  
  scale_x_continuous(limits = c(40, 101), breaks = seq(0, 100, 25)) +
  scale_y_continuous(limits = c(40, 101), breaks = seq(0, 100, 25)) +
  
  theme_bw(base_size = 12) %+replace%
  theme(aspect.ratio = 1,
        plot.background = element_rect(fill = "transparent", colour = NA), 
        panel.background = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_line(color = "grey90", lineend = "round"),
        panel.border = element_blank(),
        legend.background = element_rect(fill = "transparent", colour = NA),
        legend.key = element_rect(fill = "transparent", colour = NA),
        legend.key.width = unit(0.4, "cm"),
        legend.key.height = unit(0.4, "cm"),
        legend.position = "bottom",
        plot.title = element_text(size = 13, hjust = 0.0, vjust = 1.75, face = "bold"),
        axis.line = element_line(color = "black", linewidth = 0.6, lineend = "round"),
        axis.ticks = element_line(colour = "black", linewidth = 0.6, lineend = "round"),
        axis.ticks.length = unit(0.20, "cm"),
        axis.text.x = element_text(color = "black",
                                   margin = margin(t = 4, r = 0, b = 0, l = 0)),
        axis.text.y = element_text(color = "black",
                                   margin = margin(t = 0, r = 4, b = 0, l = 0)),
        axis.title.y = element_text(angle = 90, size = 13,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.title.x = element_text(angle = 0, size = 13,
                                    margin = margin(t = 10, r = 0, b = 0, l = 0)))



#######################
#     FINAL PANEL     #
#######################

panel <- ggpubr::ggarrange(barplot, scatter_complete, tileplot, ncol = 3, align = "h"
                           # common.legend = TRUE, legend = "bottom"
                           )
panel

ggsave(filename = "04_plots/panel.pdf",
       panel, device = cairo_pdf,
       width = 13, height = 5, units = "in", dpi = 300, bg = "white")

