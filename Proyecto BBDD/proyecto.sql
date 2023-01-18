DROP DATABASE IF EXISTS proyecto;
CREATE DATABASE proyecto;
USE proyecto;

CREATE TABLE IF NOT EXISTS tutorAlumno (
    id_tutorAlumno INT NOT NULL PRIMARY KEY,
    nombre_tutorAlumno VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS tutorEmpresa (
    id_tutorEmpresa INT NOT NULL PRIMARY KEY,
    nombre_tutorEmpresa VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS alumno (
    id_alumno INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_alumno VARCHAR(30),
    apellido_alumno VARCHAR(30),
    fechaNacimiento_alumno DATETIME,
    email_alumno VARCHAR(50),
    tlf_alumno CHAR(9),
    cicle_alumno VARCHAR(20),
    curso_alumno VARCHAR(50) NOT NULL,
    id_tutorAlumno INT,
    homologacion ENUM('FCT','DUAL'),
    FOREIGN KEY (id_tutorAlumno) REFERENCES tutorAlumno (id_tutorAlumno)
);

CREATE TABLE IF NOT EXISTS empresa (
    id_empresa INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_empresa VARCHAR(30),
    direccion_empresa VARCHAR(30),
    tlf_empresa CHAR(9),
    homologado_empresa ENUM('FCT','DUAL'),
    estudios_empresa VARCHAR(30),
    id_tutorEmpresa INT,
    homologacion ENUM('FCT','DUAL'),
    FOREIGN KEY (id_tutorEmpresa) REFERENCES tutorEmpresa (id_tutorEmpresa)
);

CREATE TABLE IF NOT EXISTS practica (
    id_practica INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_alumno INT,
    id_empresa INT,
    id_tutorAlumno INT,
    id_tutorEmpresa INT,
    dataInicio_practica DATETIME,
    dataFinal_practica DATETIME,
    totalHoras INT,
    homologacion ENUM('FCT','DUAL'),
    exencion_practica ENUM('25%', '50%', '100%'),
    FOREIGN KEY (id_alumno) REFERENCES alumno (id_alumno),
    FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa),
    FOREIGN KEY (id_tutorAlumno) REFERENCES tutorAlumno (id_tutorAlumno),
    FOREIGN KEY (id_tutorEmpresa) REFERENCES tutorEmpresa (id_tutorEmpresa)
);

delimiter //
CREATE TRIGGER practica_bi BEFORE INSERT ON practica
    FOR EACH ROW
    BEGIN

IF NEW.dataInicio_practica > NOW() THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR! No se puede introducir una prÃ¡ctica de una fecha anterior a hoy';
END IF;
END;
//
delimiter ;

delimiter //
CREATE TRIGGER practica_bu BEFORE UPDATE ON practica
    FOR EACH ROW
    BEGIN

IF NEW.dataFinal_practica < OLD.dataInicio_practica THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR! No se puede actualizar una práctica de una fecha anterior a hoy';
END IF;
END;
//
delimiter ;