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

- Error Handling

  Error handling is in place for cases where JSON files are missing or when parsing fails, with appropriate error messages being displayed.


# TODO
- Delegate Responsibilities to User and Company Classes


Currently, all processing is handled within the CompanyProcessor class. In the future, responsibilities will be delegated to User and Company classes to manage and process their respective data.
