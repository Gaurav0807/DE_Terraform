def count_lines_words_chars(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
        num_lines = len(lines)
        num_words = sum(len(line.split()) for line in lines)
        num_chars = sum(len(line) for line in lines)
    return num_lines, num_words, num_chars

def main():
    input_file = './input.txt'  # The input file should be in the same directory as this script
    output_file = './output.txt'

    num_lines, num_words, num_chars = count_lines_words_chars(input_file)

    with open(output_file, 'w') as file:
        file.write(f"Lines: {num_lines}\n")
        file.write(f"Words: {num_words}\n")
        file.write(f"Characters: {num_chars}\n")

if __name__ == "__main__":
    main()
