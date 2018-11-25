from tensorflow import keras
from keras import Sequential
from keras.layers import Dense


model = Sequential()
model.add(Dense(32, activation='relu', input_dim=100))
model.add(Dense(10, activation='softmax'))
model.compile(optimizer='rmsprop',
              loss='categorical_crossentropy',
              metrics=['accuracy'])

import numpy as np
data = np.random.random((1000, 100))
labels = np.random.randint(10, size=(1000, 1))

# one_hot编码
one_hot_labels = keras.utils.to_categorical(labels, num_classes=10)

# traning 过程
model.fit(data, one_hot_labels, epochs=10, batch_size=32)