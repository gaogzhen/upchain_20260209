// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SchoolMappingList {
    mapping(address => address) _nextStudents;
    uint public listSize;

    address constant GUARD = address(1);

    constructor() {
        _nextStudents[GUARD] = GUARD;
    }

    /**
     * @dev Adds a student to the list
     * @param student The address of the student to add
     */
    function addStudent(address student) public {
        require(!isStudent(student));

        _nextStudents[student] = _nextStudents[GUARD];
        _nextStudents[GUARD] = student;
        listSize++;
      
    }

    /**
     * @dev Removes a student from the list
     * @param student The address of the student to remove
     */
    function removeStudent(address student) public {
        require(isStudent(student));

        address prevStudent = _getPrevStudent(student);
        _nextStudents[prevStudent] = _nextStudents[student];
        _nextStudents[student] = address(0);
        listSize--;
    }

    /**
     * @dev Removes a student from the list
     * @param student The address of the student to remove
     * @param prevStudent The address of the previous student in the list, offChain computed
     */
    function removeStudent2(address student, address prevStudent) public {
        require(isStudent(student));
        require(_nextStudents[prevStudent] == student);

        _nextStudents[prevStudent] = _nextStudents[student];
        _nextStudents[student] = address(0);
        listSize--;
      
    }

    /**
     * @dev Gets the previous student in the list
     * @param student The address of the student to find
     * @return The address of the previous student
     */
    function _getPrevStudent(address student) internal view returns (address) {
        address current = GUARD;
        while (_nextStudents[current] != GUARD) {
            if (_nextStudents[current] == student) {
                return current;
            }
            current = _nextStudents[current];
        }
        return address(0);
    }

    /**
     * @dev Checks if an address is a student in the list
     * @param student The address to check
     * @return True if the address is a student, false otherwise
     */
    function isStudent(address student) public view returns (bool) {
        return _nextStudents[student] != address(0);
    }

    function getStudents() public view returns (address[] memory) {
        address[] memory students = new address[](listSize);
        address current = _nextStudents[GUARD];
        uint index = 0;
        while (current != GUARD) {
            students[index] = current;
            current = _nextStudents[current];
            index++;
        }
        return students;
      
    }
}