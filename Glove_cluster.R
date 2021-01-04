library(keras)
## library(tensorflow)
library(dplyr)

## Should be in private to be reproducible.
## setwd("/Users/2egaa/Desktop/nG-BotClassifier")
## data <- read.csv("botornot-1.csv")
data <- read.csv("private/botornot-1.csv")

## Select relevant variables and merge text variables.


data_glove <- data %>% select(c(bot, feedback, quirk))
data_glove$feedback <- as.character(data_glove$feedback)
data_glove$text <- do.call(paste0, data_glove[2:3])


## Clean-up bot variable.


data_glove$bot[is.na(data_glove$bot)] <- 0
data_glove$bot[data_glove$bot == 2] <- 1
data_glove$bot[data_glove$bot == 3] <- 1
data_glove$bot <- as.integer(data_glove$bot)


## Create train & test dataset.


data_train <- data_glove[1:1200,]
data_test <- data_glove[1201:1351,]


## Run only if pre_trained vectors are not downloaded yet.

{r eval=FALSE, include=FALSE}
if (!file.exists('glove.6B.zip')) {
  download.file('http://nlp.stanford.edu/data/glove.6B.zip',destfile = 'glove.6B.zip')
  unzip('glove.6B.zip')
}


## Read in vectors.


vectors <- data.table::fread('glove.6B.300d.txt', data.table = F,  encoding = 'UTF-8')
colnames(vectors) = c('word',paste('dim',1:300,sep = '_'))

as_tibble(vectors)


## Set parameters.


max_words = 1e4
maxlen = 60
dim_size = 300



word_seqs <- text_tokenizer(num_words = max_words) %>%
  fit_text_tokenizer(data_train$text)



x_train <- texts_to_sequences(word_seqs, data_train$text) %>%
  pad_sequences( maxlen = maxlen)



y_train <- as.matrix(data_train$bot)
word_indices <- unlist(word_seqs$word_index)



dic <- data.frame(word = names(word_indices), key = word_indices, stringsAsFactors = FALSE) %>%
  arrange(key) %>% .[1:max_words,]



word_embeds <- dic  %>% left_join(vectors) %>% .[,3:302] %>% replace(., is.na(.), 0) %>% as.matrix()



input <- layer_input(shape = list(maxlen), name = "input")

model <- input %>%
  layer_embedding(input_dim = max_words, output_dim = dim_size, input_length = maxlen,
                  weights = list(word_embeds), trainable = FALSE) %>%
  layer_spatial_dropout_1d(rate = 0.2 ) %>%
  bidirectional(
    layer_gru(units = 80, return_sequences = TRUE)
  )
max_pool <- model %>% layer_global_max_pooling_1d()
ave_pool <- model %>% layer_global_average_pooling_1d()

output = layer_concatenate(list(ave_pool, max_pool)) %>%
  layer_dense(units = 1, activation = "sigmoid")

model <- keras_model(input, output)

model %>% compile(
  optimizer = "adam",
  loss = "binary_crossentropy",
  metrics = tensorflow::tf$keras$metrics$AUC()
)

history <- model %>% keras::fit(
  x_train, y_train,
  epochs = 16,
  batch_size = 32,
  validation_split = 0.2
)



x_test <- texts_to_sequences(word_seqs, data_test$text) %>%
  pad_sequences( maxlen = maxlen)

y_test <- as.matrix(data_test$text)

pred <- model %>% predict(x_test)
format(round(pred, 2), scientific = FALSE)



model %>% evaluate(x_test, y_test, verbose = 0)



newdf <- data.frame(probabilites = format(round(pred, 2)), bot = data_test$bot)
newdf

