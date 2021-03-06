################################################################################
#
# Task Neglect vs. group size by model type
#
################################################################################

rm(list = ls())
source("scripts/__Util__MASTER.R")
source("scripts/3_PrepPlotExperimentData.R")
library(RColorBrewer)
library(scales)

# Entirely Deterministic 
load("output/__RData/MSrevision_FixedDelta06_DetThreshDetUpdateDetQuit100reps.Rdata")

noTaskPerf <- lapply(groups_taskTally, function(group_size) {
  # Loop through replicates within group size
  within_groupTaskPerf <- lapply(group_size, function(replicate) {
    # Get basics and counts of instances in which there isn't anyone performing task
    to_return <- data.frame(n = unique(replicate$n), 
                            replicate = unique(replicate$replicate),
                            Set = paste0(unique(replicate$n), "-", unique(replicate$replicate)),
                            noTask1 = sum(replicate$Task1 == 0),
                            noTask2 = sum(replicate$Task2 == 0))
    #  Quantify length of no-performance bouts
    for (task in c("Task1", "Task2")) {
      bout_lengths <- rle(replicate[ , task])
      bout_lengths <- as.data.frame(do.call("cbind", bout_lengths))
      bout_lengths <- bout_lengths %>% 
        filter(values == 0)
      avg_nonPerformance <- mean(bout_lengths$lengths)
      if(task == "Task1") {
        to_return$noTask1Length = avg_nonPerformance
      } 
      else {
        to_return$noTask2Length = avg_nonPerformance
      }
    }
    # Get averages
    to_return <- to_return %>% 
      mutate(noTaskAvg = (noTask1 + noTask2) / 2,
             noTaskLengthAvg = (noTask1Length + noTask2Length) / 2)
    # Return
    return(to_return)
  })
  # Bind and return
  within_groupTaskPerf <- do.call("rbind", within_groupTaskPerf)
  return(within_groupTaskPerf)
})
# Bind
noTaskPerf <- do.call("rbind", noTaskPerf)
noTaskPerf <- noTaskPerf %>% 
  group_by(n) %>% 
  mutate(noTask1 = noTask1 / 10000,
         noTask2 = noTask2 / 10000,
         noTaskAvg = noTaskAvg / 10000) %>% 
  summarise(TaskNegelectMean = mean(noTaskAvg, na.rm = TRUE),
            TaskNegelectSE = ( sd(noTaskAvg) / sqrt(length(noTaskAvg)) )) %>% 
  mutate(Source = "Deterministic")

taskNeglect_all <- noTaskPerf

# Probabilistic thresholds
load("output/__RData/MSrevision_FixedDelta06_DetUpdateDetQuit100reps.Rdata")

noTaskPerf <- lapply(groups_taskTally, function(group_size) {
  # Loop through replicates within group size
  within_groupTaskPerf <- lapply(group_size, function(replicate) {
    # Get basics and counts of instances in which there isn't anyone performing task
    to_return <- data.frame(n = unique(replicate$n), 
                            replicate = unique(replicate$replicate),
                            Set = paste0(unique(replicate$n), "-", unique(replicate$replicate)),
                            noTask1 = sum(replicate$Task1 == 0),
                            noTask2 = sum(replicate$Task2 == 0))
    #  Quantify length of no-performance bouts
    for (task in c("Task1", "Task2")) {
      bout_lengths <- rle(replicate[ , task])
      bout_lengths <- as.data.frame(do.call("cbind", bout_lengths))
      bout_lengths <- bout_lengths %>% 
        filter(values == 0)
      avg_nonPerformance <- mean(bout_lengths$lengths)
      if(task == "Task1") {
        to_return$noTask1Length = avg_nonPerformance
      } 
      else {
        to_return$noTask2Length = avg_nonPerformance
      }
    }
    # Get averages
    to_return <- to_return %>% 
      mutate(noTaskAvg = (noTask1 + noTask2) / 2,
             noTaskLengthAvg = (noTask1Length + noTask2Length) / 2)
    # Return
    return(to_return)
  })
  # Bind and return
  within_groupTaskPerf <- do.call("rbind", within_groupTaskPerf)
  return(within_groupTaskPerf)
})
# Bind
noTaskPerf <- do.call("rbind", noTaskPerf)
noTaskPerf <- noTaskPerf %>% 
  group_by(n) %>% 
  mutate(noTask1 = noTask1 / 10000,
         noTask2 = noTask2 / 10000,
         noTaskAvg = noTaskAvg / 10000) %>% 
  summarise(TaskNegelectMean = mean(noTaskAvg, na.rm = TRUE),
            TaskNegelectSE = ( sd(noTaskAvg) / sqrt(length(noTaskAvg)) )) %>% 
  mutate(Source = "Prob. Thresholds")

taskNeglect_all <- rbind(taskNeglect_all, noTaskPerf)


# Probabilistic quitting
load("output/__RData/MSrevision_FixedDelta06_DetThreshDetUpdate100reps.Rdata")

noTaskPerf <- lapply(groups_taskTally, function(group_size) {
  # Loop through replicates within group size
  within_groupTaskPerf <- lapply(group_size, function(replicate) {
    # Get basics and counts of instances in which there isn't anyone performing task
    to_return <- data.frame(n = unique(replicate$n), 
                            replicate = unique(replicate$replicate),
                            Set = paste0(unique(replicate$n), "-", unique(replicate$replicate)),
                            noTask1 = sum(replicate$Task1 == 0),
                            noTask2 = sum(replicate$Task2 == 0))
    #  Quantify length of no-performance bouts
    for (task in c("Task1", "Task2")) {
      bout_lengths <- rle(replicate[ , task])
      bout_lengths <- as.data.frame(do.call("cbind", bout_lengths))
      bout_lengths <- bout_lengths %>% 
        filter(values == 0)
      avg_nonPerformance <- mean(bout_lengths$lengths)
      if(task == "Task1") {
        to_return$noTask1Length = avg_nonPerformance
      } 
      else {
        to_return$noTask2Length = avg_nonPerformance
      }
    }
    # Get averages
    to_return <- to_return %>% 
      mutate(noTaskAvg = (noTask1 + noTask2) / 2,
             noTaskLengthAvg = (noTask1Length + noTask2Length) / 2)
    # Return
    return(to_return)
  })
  # Bind and return
  within_groupTaskPerf <- do.call("rbind", within_groupTaskPerf)
  return(within_groupTaskPerf)
})
# Bind
noTaskPerf <- do.call("rbind", noTaskPerf)
noTaskPerf <- noTaskPerf %>% 
  group_by(n) %>% 
  mutate(noTask1 = noTask1 / 10000,
         noTask2 = noTask2 / 10000,
         noTaskAvg = noTaskAvg / 10000) %>% 
  summarise(TaskNegelectMean = mean(noTaskAvg, na.rm = TRUE),
            TaskNegelectSE = ( sd(noTaskAvg) / sqrt(length(noTaskAvg)) )) %>% 
  mutate(Source = "Prob. Quitting")

taskNeglect_all <- rbind(taskNeglect_all, noTaskPerf)


# Probabilistic Updating
load("output/__RData/MSrevision_FixedDelta06_DetThreshDetQuit100reps.Rdata")

noTaskPerf <- lapply(groups_taskTally, function(group_size) {
  # Loop through replicates within group size
  within_groupTaskPerf <- lapply(group_size, function(replicate) {
    # Get basics and counts of instances in which there isn't anyone performing task
    to_return <- data.frame(n = unique(replicate$n), 
                            replicate = unique(replicate$replicate),
                            Set = paste0(unique(replicate$n), "-", unique(replicate$replicate)),
                            noTask1 = sum(replicate$Task1 == 0),
                            noTask2 = sum(replicate$Task2 == 0))
    #  Quantify length of no-performance bouts
    for (task in c("Task1", "Task2")) {
      bout_lengths <- rle(replicate[ , task])
      bout_lengths <- as.data.frame(do.call("cbind", bout_lengths))
      bout_lengths <- bout_lengths %>% 
        filter(values == 0)
      avg_nonPerformance <- mean(bout_lengths$lengths)
      if(task == "Task1") {
        to_return$noTask1Length = avg_nonPerformance
      } 
      else {
        to_return$noTask2Length = avg_nonPerformance
      }
    }
    # Get averages
    to_return <- to_return %>% 
      mutate(noTaskAvg = (noTask1 + noTask2) / 2,
             noTaskLengthAvg = (noTask1Length + noTask2Length) / 2)
    # Return
    return(to_return)
  })
  # Bind and return
  within_groupTaskPerf <- do.call("rbind", within_groupTaskPerf)
  return(within_groupTaskPerf)
})
# Bind
noTaskPerf <- do.call("rbind", noTaskPerf)
noTaskPerf <- noTaskPerf %>% 
  group_by(n) %>% 
  mutate(noTask1 = noTask1 / 10000,
         noTask2 = noTask2 / 10000,
         noTaskAvg = noTaskAvg / 10000) %>% 
  summarise(TaskNegelectMean = mean(noTaskAvg, na.rm = TRUE),
            TaskNegelectSE = ( sd(noTaskAvg) / sqrt(length(noTaskAvg)) )) %>% 
  mutate(Source = "Prob. Task Encounter")

taskNeglect_all <- rbind(taskNeglect_all, noTaskPerf)


# Threshold Variation
load("output/__RData/MSrevision_FixedDelta06_DetThreshWithSigmaDetUpdateDetQuit100reps.Rdata")

noTaskPerf <- lapply(groups_taskTally, function(group_size) {
  # Loop through replicates within group size
  within_groupTaskPerf <- lapply(group_size, function(replicate) {
    # Get basics and counts of instances in which there isn't anyone performing task
    to_return <- data.frame(n = unique(replicate$n), 
                            replicate = unique(replicate$replicate),
                            Set = paste0(unique(replicate$n), "-", unique(replicate$replicate)),
                            noTask1 = sum(replicate$Task1 == 0),
                            noTask2 = sum(replicate$Task2 == 0))
    #  Quantify length of no-performance bouts
    for (task in c("Task1", "Task2")) {
      bout_lengths <- rle(replicate[ , task])
      bout_lengths <- as.data.frame(do.call("cbind", bout_lengths))
      bout_lengths <- bout_lengths %>% 
        filter(values == 0)
      avg_nonPerformance <- mean(bout_lengths$lengths)
      if(task == "Task1") {
        to_return$noTask1Length = avg_nonPerformance
      } 
      else {
        to_return$noTask2Length = avg_nonPerformance
      }
    }
    # Get averages
    to_return <- to_return %>% 
      mutate(noTaskAvg = (noTask1 + noTask2) / 2,
             noTaskLengthAvg = (noTask1Length + noTask2Length) / 2)
    # Return
    return(to_return)
  })
  # Bind and return
  within_groupTaskPerf <- do.call("rbind", within_groupTaskPerf)
  return(within_groupTaskPerf)
})
# Bind
noTaskPerf <- do.call("rbind", noTaskPerf)
noTaskPerf <- noTaskPerf %>% 
  group_by(n) %>% 
  mutate(noTask1 = noTask1 / 10000,
         noTask2 = noTask2 / 10000,
         noTaskAvg = noTaskAvg / 10000) %>% 
  summarise(TaskNegelectMean = mean(noTaskAvg, na.rm = TRUE),
            TaskNegelectSE = ( sd(noTaskAvg) / sqrt(length(noTaskAvg)) )) %>% 
  mutate(Source = "Threshold Variation")

taskNeglect_all <- rbind(taskNeglect_all, noTaskPerf)


# Original model
load("output/__RData/FixedDelta06Sigma01Eta7100reps.Rdata")

noTaskPerf <- lapply(groups_taskTally, function(group_size) {
  # Loop through replicates within group size
  within_groupTaskPerf <- lapply(group_size, function(replicate) {
    # Get basics and counts of instances in which there isn't anyone performing task
    to_return <- data.frame(n = unique(replicate$n), 
                            replicate = unique(replicate$replicate),
                            Set = paste0(unique(replicate$n), "-", unique(replicate$replicate)),
                            noTask1 = sum(replicate$Task1 == 0),
                            noTask2 = sum(replicate$Task2 == 0))
    #  Quantify length of no-performance bouts
    for (task in c("Task1", "Task2")) {
      bout_lengths <- rle(replicate[ , task])
      bout_lengths <- as.data.frame(do.call("cbind", bout_lengths))
      bout_lengths <- bout_lengths %>% 
        filter(values == 0)
      avg_nonPerformance <- mean(bout_lengths$lengths)
      if(task == "Task1") {
        to_return$noTask1Length = avg_nonPerformance
      } 
      else {
        to_return$noTask2Length = avg_nonPerformance
      }
    }
    # Get averages
    to_return <- to_return %>% 
      mutate(noTaskAvg = (noTask1 + noTask2) / 2,
             noTaskLengthAvg = (noTask1Length + noTask2Length) / 2)
    # Return
    return(to_return)
  })
  # Bind and return
  within_groupTaskPerf <- do.call("rbind", within_groupTaskPerf)
  return(within_groupTaskPerf)
})
# Bind
noTaskPerf <- do.call("rbind", noTaskPerf)
noTaskPerf <- noTaskPerf %>% 
  group_by(n) %>% 
  mutate(noTask1 = noTask1 / 10000,
         noTask2 = noTask2 / 10000,
         noTaskAvg = noTaskAvg / 10000) %>% 
  summarise(TaskNegelectMean = mean(noTaskAvg, na.rm = TRUE),
            TaskNegelectSE = ( sd(noTaskAvg) / sqrt(length(noTaskAvg)) )) %>% 
  mutate(Source = "Full Model")

taskNeglect_all <- rbind(taskNeglect_all, noTaskPerf)

taskNeglect_all$Source <- factor(taskNeglect_all$Source, levels = c("Deterministic",
                                                                    "Prob. Task Encounter",
                                                                    "Prob. Quitting",
                                                                    "Prob. Thresholds",
                                                                    "Threshold Variation",
                                                                    "Full Model"))

# Plot all
gg_models <- ggplot(data = taskNeglect_all) +
  geom_line(aes(x = n, y = TaskNegelectMean, colour = Source)) +
  geom_errorbar(aes(x = n, ymin = TaskNegelectMean - TaskNegelectSE, ymax = TaskNegelectMean + TaskNegelectSE, colour = Source),
                width = 1) +
  geom_point(aes(x = n, y = TaskNegelectMean, colour = Source),
             size = 1.5) +
  theme_classic() +
  scale_color_brewer(palette = "Set2") +
  scale_x_continuous(breaks = unique(taskNeglect_all$n)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 0.8)) +
  xlab("Group size") +
  ylab("Task negelect") +
  theme(legend.position = "none",
        legend.justification = c(1, 1),
        legend.title = element_blank(),
        legend.key.height = unit(0.3, "cm"),
        legend.key.width= unit(0.4, "cm"),
        legend.margin =  margin(t = 0, r = 0, b = 0, l = -0.2, "cm"),
        legend.text = element_text(size = 10),
        legend.text.align = 0,
        # legend.box.background = element_rect(),
        axis.text.y = element_text(size = 8, margin = margin(5, 6, 5, -2), color = "black"),
        axis.text.x = element_text(size = 8, margin = margin(6, 5, -2, 5), color = "black"),
        axis.title = element_text(size = 10, margin = margin(0, 0, 0, 0)),
        axis.ticks.length = unit(-0.1, "cm"),
        aspect.ratio = 1)

gg_models


ggsave("output/StochasticElements/TaskNeglectByModelType.png", width = 2, height = 2, dpi = 600, unit = "in")
