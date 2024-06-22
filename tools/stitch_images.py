import os
from PIL import Image
import tkinter as tk
from tkinter import filedialog

# Function to read all images from a directory and return them in alphabetical order
def read_images_from_directory(directory):
    files = sorted([f for f in os.listdir(directory) if f.endswith(('png', 'jpg', 'jpeg'))])
    images = [Image.open(os.path.join(directory, f)).convert("RGBA") for f in files]
    return images

# Function to remove the bottom transparent portion of an image
def crop_bottom_transparent(image):
    # Get the alpha channel of the image
    alpha = image.split()[-1]
    # Find the lowest non-transparent pixel
    non_transparent = alpha.getdata()
    bottom = len(non_transparent) - 1
    while bottom >= 0 and non_transparent[bottom] == 0:
        bottom -= 1
    if bottom < 0:
        return image  # Image is fully transparent

    bottom = bottom // image.width
    return image.crop((0, 0, image.width, bottom + 1))

# Function to determine the max height and width of images
def get_max_dimensions(images):
    max_height = max(image.height for image in images)
    max_width = max(image.width for image in images)
    return max_height, max_width

# Main function to create the final image grid
def create_image_grid(images, grid_width, grid_height, output_path):
    # Crop images to remove bottom transparent portions
    cropped_images = [crop_bottom_transparent(image) for image in images]

    max_height, max_width = get_max_dimensions(cropped_images)
    max_size = max(max_height, max_width)
    
    # Create a new image with the specified grid dimensions
    grid_image = Image.new('RGBA', (grid_width * max_size, grid_height * max_size), (255, 255, 255, 0))

    for index, image in enumerate(cropped_images):
        row = index // grid_width
        col = index % grid_width
        x = col * max_size + (max_size - image.width) // 2
        y = (row + 1) * max_size - image.height
        grid_image.paste(image, (x, y), image)

    grid_image.save(output_path)

# Function to open directory chooser dialog
def choose_directory():
    root = tk.Tk()
    root.withdraw()
    directory = filedialog.askdirectory()
    return directory

# Function to open save file dialog
def choose_save_file():
    root = tk.Tk()
    root.withdraw()
    file_path = filedialog.asksaveasfilename(defaultextension=".png", filetypes=[("PNG files", "*.png")])
    return file_path

# Main script execution
if __name__ == "__main__":
    # Use tkinter to choose the directory of images
    image_directory = choose_directory()
    
    # Use tkinter to choose where to save the final PNG
    output_image_path = choose_save_file()

    if image_directory and output_image_path:
        # Constants for grid dimensions
        grid_width = 14
        grid_height = 5

        # Read images and create the image grid
        images = read_images_from_directory(image_directory)
        create_image_grid(images, grid_width, grid_height, output_image_path)

        print(f"Image grid saved to {output_image_path}")
    else:
        print("Directory or output path not selected.")
