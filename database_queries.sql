SELECT C.ID, C.Intitule, COUNT(IC.Utilisateur_ID) AS NombreInscrits
FROM Cours C
JOIN Inscription_Cours IC ON C.ID = IC.Session_Direct_ID
GROUP BY C.ID
ORDER BY NombreInscrits DESC;


SELECT C.ID, C.Intitule, AVG(E.Note) AS NoteMoyenne
FROM Cours C
JOIN Evaluation E ON C.ID = E.Cours_ID
GROUP BY C.ID
ORDER BY NoteMoyenne DESC;

--  Vérifier le nombre de sections avec l'ID de cours 4 检查课程ID为4的章节数量
SELECT COUNT(*)
FROM Partie Pa
JOIN Chapitre Ch ON Pa.Chapitre_ID = Ch.ID
WHERE Ch.Cours_ID = 4;

-- Vérification de tous les utilisateurs qui ont suivi des parties du cours 4 检查所有完成课程4的部分的用户
SELECT U.ID, U.Nom, U.Prenom, COUNT(DISTINCT Pa.ID) as CompletedParts
FROM Utilisateur U
JOIN Inscription_Cours IC ON U.ID = IC.Utilisateur_ID
JOIN Progression P ON IC.ID = P.Inscription_Cours_ID
JOIN Partie Pa ON P.Partie_ID = Pa.ID
JOIN Chapitre Ch ON Pa.Chapitre_ID = Ch.ID
WHERE Ch.Cours_ID = 4 AND P.Termine = TRUE
GROUP BY U.ID, U.Nom, U.Prenom
HAVING COUNT(DISTINCT Pa.ID) > 0;

-- //to be tested
SELECT U.ID, U.Nom, U.Prenom
FROM Utilisateur U
JOIN Inscription_Cours IC ON U.ID = IC.Utilisateur_ID
JOIN Progression P ON IC.ID = P.Inscription_Cours_ID
JOIN Partie Pa ON P.Partie_ID = Pa.ID
JOIN Chapitre Ch ON Pa.Chapitre_ID = Ch.ID
WHERE Ch.Cours_ID = 4 AND P.Termine = TRUE
GROUP BY U.ID
HAVING COUNT(DISTINCT Pa.ID) = (
    SELECT COUNT(*)
    FROM Partie Pa
    JOIN Chapitre Ch ON Pa.Chapitre_ID = Ch.ID
    WHERE Ch.Cours_ID = 4)


-- Vérifier le nombre d'examens avec l'ID de cours 2  检查课程ID为2的考试数量
SELECT COUNT(*)
FROM Examen E
JOIN Partie Pa ON E.Partie_ID = Pa.ID
JOIN Chapitre Ch ON Pa.Chapitre_ID = Ch.ID
WHERE Ch.Cours_ID = 2;

-- Vérifier tous les utilisateurs qui ont tenté l'examen du cours 2 检查所有尝试过课程2考试的用户
SELECT U.ID, U.Nom, U.Prenom, COUNT(DISTINCT E.ID) as AttemptedExams
FROM Utilisateur U
JOIN Inscription_Cours IC ON U.ID = IC.Utilisateur_ID
JOIN Tentative T ON IC.ID = T.Inscription_Cours_ID
JOIN Examen E ON T.Examen_ID = E.ID
JOIN Partie Pa ON E.Partie_ID = Pa.ID
JOIN Chapitre Ch ON Pa.Chapitre_ID = Ch.ID
WHERE Ch.Cours_ID = 2
GROUP BY U.ID, U.Nom, U.Prenom;

-- //???????  
SELECT DISTINCT U.ID, U.Nom, U.Prenom
FROM Utilisateur U
JOIN Inscription_Cours IC ON U.ID = IC.Utilisateur_ID
JOIN Tentative T ON IC.ID = T.Inscription_Cours_ID
JOIN Examen E ON T.Examen_ID = E.ID
JOIN Partie Pa ON E.Partie_ID = Pa.ID
JOIN Chapitre Ch ON Pa.Chapitre_ID = Ch.ID
WHERE Ch.Cours_ID = 2
GROUP BY U.ID
HAVING COUNT(DISTINCT E.ID) = (SELECT COUNT(*) FROM Examen E JOIN Partie Pa ON E.Partie_ID = Pa.ID JOIN Chapitre Ch ON Pa.Chapitre_ID = Ch.ID WHERE Ch.Cours_ID = 2);


-- Vérifier le nombre d'examens avec l'ID de cours 1 检查课程ID为1的考试数量
SELECT COUNT(*)
FROM Examen E
JOIN Partie Pa ON E.Partie_ID = Pa.ID
JOIN Chapitre Ch ON Pa.Chapitre_ID = Ch.ID
WHERE Ch.Cours_ID = 1;

-- Vérification des dossiers des examens qui satisfont aux exigences minimales en matière de résultats 检查达到最低分数要求的考试记录
SELECT T.Score, E.ScoreMin
FROM Tentative T
JOIN Examen E ON T.Examen_ID = E.ID
WHERE T.Score >= E.ScoreMin;

SELECT U.ID, U.Nom, U.Prenom, COUNT(DISTINCT E.ID) as PassedExams
FROM Utilisateur U
JOIN Inscription_Cours IC ON U.ID = IC.Utilisateur_ID
JOIN Tentative T ON IC.ID = T.Inscription_Cours_ID
JOIN Examen E ON T.Examen_ID = E.ID
JOIN Partie Pa ON E.Partie_ID = Pa.ID
JOIN Chapitre Ch ON Pa.Chapitre_ID = Ch.ID
WHERE Ch.Cours_ID = 1 AND T.Score >= E.ScoreMin
GROUP BY U.ID, U.Nom, U.Prenom;


SELECT U.ID, U.Nom, U.Prenom, SUM(C.Prix) AS MontantDepense
FROM Utilisateur U
JOIN Inscription_Cours IC ON U.ID = IC.Utilisateur_ID
JOIN Session_Direct SD ON IC.Session_Direct_ID = SD.ID
JOIN Cours C ON SD.Cours_ID = C.ID
WHERE IC.Payant = TRUE
GROUP BY U.ID
ORDER BY MontantDepense DESC;


SELECT Ch.OrdreChapitre, Ch.ChapitreNom, Pa.OrdrePartie, Pa.TitrePartie
FROM Chapitre Ch
JOIN Partie Pa ON Ch.ID = Pa.Chapitre_ID
WHERE Ch.Cours_ID = 1
ORDER BY Ch.OrdreChapitre, Pa.OrdrePartie;

//done
SELECT C.ID, C.Intitule, U.Nom AS CreateurNom, U.Prenom AS CreateurPrenom
FROM Cours C
JOIN Creation Cr ON C.ID = Cr.Cours_ID
JOIN Utilisateur U ON Cr.Utilisateur_ID = U.ID

UNION

SELECT C.ID, C.Intitule, U.Nom AS CreateurNom, U.Prenom AS CreateurPrenom
FROM Cours C
JOIN Assignation A ON C.ID = A.Cours_ID
JOIN Utilisateur U ON A.Utilisateur_ID = U.ID

ORDER BY 1;

-- //Vérifiez qu il y a des enregistrements dans les tables Inscription_Courses et Progression qui ont un ID utilisateur de 2 et qui ont Termine TRUE.确认Inscription_Cours和Progression表中存在用户ID为2的记录，并且有Termine = TRUE的记录
SELECT *
FROM Inscription_Cours IC
WHERE Utilisateur_ID = 2;
SELECT *
FROM Progression P
JOIN Inscription_Cours IC ON P.Inscription_Cours_ID = IC.ID
WHERE IC.Utilisateur_ID = 2 AND P.Termine = TRUE;

-- //Vérifier que la sous-requête (Calculer les notes de QG pour chaque cours) renvoie la bonne valeur. 确认子查询（计算每个课程的总部分数）返回的是正确的值
SELECT C.ID, COUNT(*) AS TotalParties
FROM Partie Pa
JOIN Chapitre Ch ON Pa.Chapitre_ID = Ch.ID
JOIN Cours C ON Ch.Cours_ID = C.ID
WHERE C.ID IN (SELECT DISTINCT Session_Direct_ID FROM Inscription_Cours WHERE Utilisateur_ID = 2)
GROUP BY C.ID;


SELECT 
    IC.Session_Direct_ID AS CoursID, 
    (CAST(COUNT(DISTINCT P.ID) AS FLOAT) / NULLIF(
        (SELECT COUNT(*) 
         FROM Partie Pa 
         JOIN Chapitre Ch ON Pa.Chapitre_ID = Ch.ID 
         JOIN Cours C ON Ch.Cours_ID = C.ID 
         WHERE C.ID = IC.Session_Direct_ID), 
        0)
    )*100 AS PourcentageProgression
FROM Inscription_Cours IC
JOIN Progression P ON IC.ID = P.Inscription_Cours_ID AND P.Termine = TRUE
WHERE IC.Utilisateur_ID = 2
GROUP BY IC.Session_Direct_ID;