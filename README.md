Technical Assignment for the Full Stack (React/Ruby) Developer position at Thrive Career Wellness

# How to Run

Run the following command to execute the processing:
```
ruby challenge.rb
```
The results will be output to the output.txt file.


# Implementation
- Class Refactoring

  The logic has been refactored into the CompanyProcessor class for better readability and maintainability. The process of loading data and handling the workflow is now clearer.

- Delegation of Responsibilities

  The data processing for users and companies has been moved from the CompanyProcessor class to the User and Company classes. Each class has its own responsibilities for loading, formatting, and outputting data.

- Error Handling

  Error handling is in place for cases where JSON files are missing or when parsing fails, with appropriate error messages being displayed.

# Future Outlook
- Improvements will be made to data integrity and handling of invalid data.
- Unit tests will be created for each class to enhance reliability.
