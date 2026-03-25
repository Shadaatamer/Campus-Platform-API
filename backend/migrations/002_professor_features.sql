-- ===============================
-- Professor Features Schema
-- ===============================

-- Courses Table
CREATE TABLE IF NOT EXISTS courses (
  course_id SERIAL PRIMARY KEY,
  code VARCHAR(20) NOT NULL UNIQUE,
  name TEXT NOT NULL,
  credits INT NOT NULL DEFAULT 3,
  department_id INT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  
  CONSTRAINT fk_course_department
    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
    ON DELETE CASCADE
);

-- Classes Table (a class is a section of a course taught by a professor)
CREATE TABLE IF NOT EXISTS classes (
  class_id SERIAL PRIMARY KEY,
  course_id INT NOT NULL,
  professor_id INT NOT NULL,
  semester VARCHAR(10) NOT NULL, -- e.g., "Fall 2024", "Spring 2025"
  section VARCHAR(10), -- e.g., "A", "B", "C"
  max_capacity INT DEFAULT 50,
  day TEXT, -- Monday, Tuesday, etc.
  time_start TIME,
  time_end TIME,
  location TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  
  CONSTRAINT fk_class_course
    FOREIGN KEY (course_id)
    REFERENCES courses(course_id)
    ON DELETE CASCADE,
  
  CONSTRAINT fk_class_professor
    FOREIGN KEY (professor_id)
    REFERENCES professors(professor_id)
    ON DELETE CASCADE
);

-- Enrollments Table (students enrolled in classes)
CREATE TABLE IF NOT EXISTS enrollments (
  enrollment_id SERIAL PRIMARY KEY,
  class_id INT NOT NULL,
  student_id INT NOT NULL,
  enrolled_at TIMESTAMP NOT NULL DEFAULT NOW(),
  
  CONSTRAINT fk_enrollment_class
    FOREIGN KEY (class_id)
    REFERENCES classes(class_id)
    ON DELETE CASCADE,
  
  CONSTRAINT fk_enrollment_student
    FOREIGN KEY (student_id)
    REFERENCES students(student_id)
    ON DELETE CASCADE,
  
  CONSTRAINT unique_class_student
    UNIQUE (class_id, student_id)
);

-- Grades Table
CREATE TABLE IF NOT EXISTS grades (
  grade_id SERIAL PRIMARY KEY,
  enrollment_id INT NOT NULL,
  assessment_type VARCHAR(50) NOT NULL, -- e.g., "Midterm", "Final", "Quiz1", "Project"
  score DECIMAL(5, 2) NOT NULL,
  max_score DECIMAL(5, 2) NOT NULL DEFAULT 100,
  graded_at TIMESTAMP NOT NULL DEFAULT NOW(),
  
  CONSTRAINT fk_grade_enrollment
    FOREIGN KEY (enrollment_id)
    REFERENCES enrollments(enrollment_id)
    ON DELETE CASCADE
);

-- Attendance Table
CREATE TABLE IF NOT EXISTS attendance (
  attendance_id SERIAL PRIMARY KEY,
  enrollment_id INT NOT NULL,
  class_date DATE NOT NULL,
  status VARCHAR(20) NOT NULL, -- "Present", "Absent", "Late", "Excused"
  notes TEXT,
  recorded_at TIMESTAMP NOT NULL DEFAULT NOW(),
  
  CONSTRAINT fk_attendance_enrollment
    FOREIGN KEY (enrollment_id)
    REFERENCES enrollments(enrollment_id)
    ON DELETE CASCADE,
  
  CONSTRAINT unique_attendance
    UNIQUE (enrollment_id, class_date)
);

-- Course Announcements Table (different from global announcements)
CREATE TABLE IF NOT EXISTS course_announcements (
  announcement_id SERIAL PRIMARY KEY,
  class_id INT NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  created_by INT NOT NULL,
  is_published BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  
  CONSTRAINT fk_announce_class
    FOREIGN KEY (class_id)
    REFERENCES classes(class_id)
    ON DELETE CASCADE,
  
  CONSTRAINT fk_announce_user
    FOREIGN KEY (created_by)
    REFERENCES users(user_id)
    ON DELETE CASCADE
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_classes_professor ON classes(professor_id);
CREATE INDEX IF NOT EXISTS idx_classes_course ON classes(course_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_class ON enrollments(class_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_student ON enrollments(student_id);
CREATE INDEX IF NOT EXISTS idx_grades_enrollment ON grades(enrollment_id);
CREATE INDEX IF NOT EXISTS idx_attendance_enrollment ON attendance(enrollment_id);
CREATE INDEX IF NOT EXISTS idx_course_announcements_class ON course_announcements(class_id);
