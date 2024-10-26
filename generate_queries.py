import csv
import datetime

def create_table_query():
    return """
    CREATE TABLE Movies (
        Movie_ID INT AUTO_INCREMENT PRIMARY KEY,
        Title VARCHAR(200),
        Duration TIME,
        Revenue FLOAT,
        Release_Date DATE,
        Description VARCHAR(2000),
        Movie_Rating FLOAT,
        Num_Ratings_Movies INT
    );
    """

def format_value(value):
    if value == '' or value == 'N/A':
        return 'NULL'
    try:
        float(value.replace(',', ''))
        return value.replace(',', '')
    except ValueError:
        return f"'{value.replace("'", "''")}'"

def generate_insert_query(row):
    try:
        title = row[1]
        year = row[2]
        duration = row[4].split()[0]  # Assuming duration is in format "XXX min"
        revenue = row[15].replace(',', '').replace('$', '') if row[15] else 'NULL'  # Gross (Revenue)
        description = row[7]
        rating = row[6]
        num_ratings = row[14].replace(',', '')  # No. of Votes

        # Convert duration to TIME format
        duration_time = datetime.time(int(duration) // 60, int(duration) % 60)

        values = [
            format_value(title),
            f"'{duration_time}'",
            revenue,
            f"'{year}-01-01'",
            format_value(description),
            rating,
            num_ratings
        ]

        return f"INSERT INTO Movies (Title, Duration, Revenue, Release_Date, Description, Movie_Rating, Num_Ratings_Movies) VALUES ({', '.join(values)});"
    except Exception as e:
        raise Exception(f"Error processing row: {row}\nSpecific error: {str(e)}")

def main():
    with open('imdb_top_1000.csv', 'r', encoding='utf-8') as file:
        reader = csv.reader(file)
        next(reader)  # Skip header row

        print(create_table_query())
        
        for index, row in enumerate(reader, start=1):
            try:
                print(generate_insert_query(row))
            except Exception as e:
                print(f"Error in row {index}:")
                print(str(e))
                print("Skipping this row and continuing...\n")

if __name__ == "__main__":
    main()