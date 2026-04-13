"""
Potato Leaf Disease Detection using CNN
Task 4 - Image Classification Project
Classes: Early Blight | Late Blight | Healthy
"""

# ──────────────────────────────────────────────
# 0. Imports
# ──────────────────────────────────────────────
import os
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import seaborn as sns
import warnings
warnings.filterwarnings("ignore")

import tensorflow as tf
from tensorflow.keras import layers, models, callbacks
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from sklearn.metrics import classification_report, confusion_matrix

# Optional – only needed if you download via kagglehub
# import kagglehub
# path = kagglehub.dataset_download("hafiznouman786/potato-plant-diseases-data")
# print("Dataset path:", path)

# ──────────────────────────────────────────────
# 1. Configuration
# ──────────────────────────────────────────────
DATASET_DIR   = "./potato-plant-diseases-data"   # adjust to your path
IMG_SIZE      = (128, 128)
BATCH_SIZE    = 32
EPOCHS        = 20
NUM_CLASSES   = 3
CLASS_NAMES   = ["Early Blight", "Late Blight", "Healthy"]
SEED          = 42
tf.random.set_seed(SEED)
np.random.seed(SEED)

# ──────────────────────────────────────────────
# 2. Data Loading & Exploration
# ──────────────────────────────────────────────
print("\n" + "="*55)
print("  STEP 1 — Data Understanding")
print("="*55)

# Build generators
datagen_args = dict(
    rescale=1.0/255,
    validation_split=0.2,
)

train_gen = ImageDataGenerator(
    **datagen_args,
    rotation_range=30,
    width_shift_range=0.15,
    height_shift_range=0.15,
    shear_range=0.15,
    zoom_range=0.2,
    horizontal_flip=True,
    vertical_flip=False,
    fill_mode="nearest",
)

val_gen = ImageDataGenerator(rescale=1.0/255, validation_split=0.2)

train_ds = train_gen.flow_from_directory(
    DATASET_DIR,
    target_size=IMG_SIZE,
    batch_size=BATCH_SIZE,
    class_mode="categorical",
    subset="training",
    seed=SEED,
)

val_ds = val_gen.flow_from_directory(
    DATASET_DIR,
    target_size=IMG_SIZE,
    batch_size=BATCH_SIZE,
    class_mode="categorical",
    subset="validation",
    seed=SEED,
)

print(f"\nTraining samples   : {train_ds.samples}")
print(f"Validation samples : {val_ds.samples}")
print(f"Classes found      : {list(train_ds.class_indices.keys())}")

# ── Visualise sample images ──────────────────
print("\nGenerating sample image grid …")
sample_images, sample_labels = next(train_ds)
idx_to_class = {v: k for k, v in train_ds.class_indices.items()}

fig, axes = plt.subplots(3, 6, figsize=(16, 8))
fig.suptitle("Sample Images — Potato Leaf Disease Dataset",
             fontsize=14, fontweight="bold", y=1.01)
shown = {c: 0 for c in range(NUM_CLASSES)}
ptr   = 0
for ax in axes.flatten():
    cls  = np.argmax(sample_labels[ptr])
    img  = sample_images[ptr]
    ax.imshow(img)
    ax.set_title(idx_to_class[cls], fontsize=9)
    ax.axis("off")
    ptr += 1
plt.tight_layout()
plt.savefig("sample_images.png", dpi=150, bbox_inches="tight")
plt.show()
print("Saved → sample_images.png")

# ── Class distribution ───────────────────────
class_counts = {k: 0 for k in train_ds.class_indices}
for cls_name, idx in train_ds.class_indices.items():
    folder = os.path.join(DATASET_DIR, cls_name)
    if os.path.isdir(folder):
        class_counts[cls_name] = len(os.listdir(folder))

fig, ax = plt.subplots(figsize=(7, 4))
colors = ["#e07b39", "#3a7ebf", "#4caf72"]
bars   = ax.bar(class_counts.keys(), class_counts.values(), color=colors, width=0.5)
ax.bar_label(bars, padding=4, fontsize=11, fontweight="bold")
ax.set_title("Class Distribution", fontsize=13, fontweight="bold")
ax.set_ylabel("Image Count")
ax.set_ylim(0, max(class_counts.values()) * 1.15)
plt.tight_layout()
plt.savefig("class_distribution.png", dpi=150, bbox_inches="tight")
plt.show()
print("Saved → class_distribution.png")

# ──────────────────────────────────────────────
# 3. Model Building — Custom CNN
# ──────────────────────────────────────────────
print("\n" + "="*55)
print("  STEP 3 — Model Architecture")
print("="*55)

def build_cnn(input_shape=(128, 128, 3), num_classes=3):
    model = models.Sequential([
        # ── Block 1 ──────────────────────────
        layers.Conv2D(32, (3,3), activation="relu", padding="same",
                      input_shape=input_shape),
        layers.BatchNormalization(),
        layers.Conv2D(32, (3,3), activation="relu", padding="same"),
        layers.MaxPooling2D((2,2)),
        layers.Dropout(0.25),

        # ── Block 2 ──────────────────────────
        layers.Conv2D(64, (3,3), activation="relu", padding="same"),
        layers.BatchNormalization(),
        layers.Conv2D(64, (3,3), activation="relu", padding="same"),
        layers.MaxPooling2D((2,2)),
        layers.Dropout(0.25),

        # ── Block 3 ──────────────────────────
        layers.Conv2D(128, (3,3), activation="relu", padding="same"),
        layers.BatchNormalization(),
        layers.Conv2D(128, (3,3), activation="relu", padding="same"),
        layers.MaxPooling2D((2,2)),
        layers.Dropout(0.3),

        # ── Block 4 ──────────────────────────
        layers.Conv2D(256, (3,3), activation="relu", padding="same"),
        layers.BatchNormalization(),
        layers.MaxPooling2D((2,2)),
        layers.Dropout(0.3),

        # ── Classifier ───────────────────────
        layers.GlobalAveragePooling2D(),
        layers.Dense(256, activation="relu"),
        layers.BatchNormalization(),
        layers.Dropout(0.4),
        layers.Dense(num_classes, activation="softmax"),
    ], name="PotatoCNN")
    return model

model = build_cnn(input_shape=(*IMG_SIZE, 3), num_classes=NUM_CLASSES)
model.summary()

model.compile(
    optimizer=tf.keras.optimizers.Adam(learning_rate=1e-3),
    loss="categorical_crossentropy",
    metrics=["accuracy"],
)

# ──────────────────────────────────────────────
# 4. Model Training
# ──────────────────────────────────────────────
print("\n" + "="*55)
print("  STEP 4 — Training")
print("="*55)

cb_list = [
    callbacks.EarlyStopping(monitor="val_loss", patience=5,
                            restore_best_weights=True, verbose=1),
    callbacks.ReduceLROnPlateau(monitor="val_loss", factor=0.4,
                                patience=3, min_lr=1e-6, verbose=1),
    callbacks.ModelCheckpoint("best_potato_cnn.keras",
                               monitor="val_accuracy",
                               save_best_only=True, verbose=1),
]

history = model.fit(
    train_ds,
    validation_data=val_ds,
    epochs=EPOCHS,
    callbacks=cb_list,
    verbose=1,
)

print("\n✅ Training complete.")

# ──────────────────────────────────────────────
# 5. Training Curves
# ──────────────────────────────────────────────
def plot_history(hist):
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(13, 5))
    fig.suptitle("Training History", fontsize=14, fontweight="bold")

    epochs_range = range(1, len(hist.history["accuracy"]) + 1)

    # Accuracy
    ax1.plot(epochs_range, hist.history["accuracy"],     "o-", color="#3a7ebf", label="Train Accuracy")
    ax1.plot(epochs_range, hist.history["val_accuracy"], "s--",color="#e07b39", label="Val Accuracy")
    ax1.set_title("Model Accuracy"); ax1.set_xlabel("Epoch"); ax1.set_ylabel("Accuracy")
    ax1.legend(); ax1.grid(alpha=0.3)

    # Loss
    ax2.plot(epochs_range, hist.history["loss"],     "o-", color="#3a7ebf", label="Train Loss")
    ax2.plot(epochs_range, hist.history["val_loss"], "s--",color="#e07b39", label="Val Loss")
    ax2.set_title("Model Loss"); ax2.set_xlabel("Epoch"); ax2.set_ylabel("Loss")
    ax2.legend(); ax2.grid(alpha=0.3)

    plt.tight_layout()
    plt.savefig("training_history.png", dpi=150, bbox_inches="tight")
    plt.show()
    print("Saved → training_history.png")

plot_history(history)

# ──────────────────────────────────────────────
# 6. Model Evaluation
# ──────────────────────────────────────────────
print("\n" + "="*55)
print("  STEP 5 — Evaluation")
print("="*55)

# ── Accuracy on validation set ───────────────
val_loss, val_acc = model.evaluate(val_ds, verbose=0)
print(f"\nValidation Loss     : {val_loss:.4f}")
print(f"Validation Accuracy : {val_acc*100:.2f}%")

# ── Predictions ──────────────────────────────
y_true, y_pred = [], []
for images, labels in val_ds:
    preds = model.predict(images, verbose=0)
    y_true.extend(np.argmax(labels, axis=1))
    y_pred.extend(np.argmax(preds,  axis=1))
    if len(y_true) >= val_ds.samples:
        break

y_true = np.array(y_true)[:val_ds.samples]
y_pred = np.array(y_pred)[:val_ds.samples]

# ── Confusion Matrix ─────────────────────────
cm = confusion_matrix(y_true, y_pred)
fig, ax = plt.subplots(figsize=(7, 6))
sns.heatmap(cm, annot=True, fmt="d", cmap="Blues",
            xticklabels=list(train_ds.class_indices.keys()),
            yticklabels=list(train_ds.class_indices.keys()),
            linewidths=0.5, ax=ax)
ax.set_title("Confusion Matrix", fontsize=13, fontweight="bold")
ax.set_xlabel("Predicted Label", fontsize=11)
ax.set_ylabel("True Label",      fontsize=11)
plt.tight_layout()
plt.savefig("confusion_matrix.png", dpi=150, bbox_inches="tight")
plt.show()
print("Saved → confusion_matrix.png")

# ── Classification Report ────────────────────
print("\nClassification Report:")
print("-"*55)
print(classification_report(y_true, y_pred,
                             target_names=list(train_ds.class_indices.keys())))

# ── Per-class accuracy bar chart ─────────────
per_class_acc = cm.diagonal() / cm.sum(axis=1)
fig, ax = plt.subplots(figsize=(7, 4))
colors_bar = ["#e07b39", "#3a7ebf", "#4caf72"]
bars = ax.bar(list(train_ds.class_indices.keys()), per_class_acc * 100,
              color=colors_bar, width=0.45)
ax.bar_label(bars, fmt="%.1f%%", padding=4, fontsize=11, fontweight="bold")
ax.set_ylim(0, 115)
ax.set_title("Per-Class Accuracy", fontsize=13, fontweight="bold")
ax.set_ylabel("Accuracy (%)")
plt.tight_layout()
plt.savefig("per_class_accuracy.png", dpi=150, bbox_inches="tight")
plt.show()
print("Saved → per_class_accuracy.png")

# ──────────────────────────────────────────────
# 7. Prediction Demo — show 12 random val images
# ──────────────────────────────────────────────
print("\nGenerating prediction demo …")
sample_imgs, sample_lbls = next(val_ds)
preds = model.predict(sample_imgs, verbose=0)

fig, axes = plt.subplots(3, 4, figsize=(14, 10))
fig.suptitle("Prediction Demo (Green=Correct | Red=Wrong)",
             fontsize=13, fontweight="bold")
classes = list(train_ds.class_indices.keys())
for i, ax in enumerate(axes.flatten()):
    if i >= len(sample_imgs):
        ax.axis("off"); continue
    true_cls = classes[np.argmax(sample_lbls[i])]
    pred_cls = classes[np.argmax(preds[i])]
    conf     = np.max(preds[i]) * 100
    correct  = true_cls == pred_cls
    color    = "#2e7d32" if correct else "#c62828"
    ax.imshow(sample_imgs[i])
    ax.set_title(f"True: {true_cls}\nPred: {pred_cls} ({conf:.1f}%)",
                 fontsize=8, color=color, fontweight="bold")
    for spine in ax.spines.values():
        spine.set_edgecolor(color); spine.set_linewidth(2.5)
    ax.tick_params(bottom=False, left=False, labelbottom=False, labelleft=False)
plt.tight_layout()
plt.savefig("prediction_demo.png", dpi=150, bbox_inches="tight")
plt.show()
print("Saved → prediction_demo.png")

# ──────────────────────────────────────────────
# 8. Final Summary
# ──────────────────────────────────────────────
print("\n" + "="*55)
print("  FINAL SUMMARY")
print("="*55)
print(f"  Model saved   : best_potato_cnn.keras")
print(f"  Val Accuracy  : {val_acc*100:.2f}%")
print(f"  Val Loss      : {val_loss:.4f}")
print(f"  Plots saved   : sample_images.png, class_distribution.png,")
print(f"                  training_history.png, confusion_matrix.png,")
print(f"                  per_class_accuracy.png, prediction_demo.png")
print("="*55)
