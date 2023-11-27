-- 1)
SELECT * FROM P01_Equipe WHERE Equipe_Nom ~ '^A';

-- 2) 1)
-- inner join
SELECT * FROM P01_Rencontre R INNER JOIN P01_Oppose O ON R.Match_Id = O.Match_Id;
-- TEMPS D EXECUTION 12ms
SELECT *
FROM P01_Rencontre R
NATURAL JOIN P01_Oppose O;
-- TEMPS D EXECUTION 13 ms
-- LEFT JOIN :
SELECT * FROM P01_Rencontre R LEFT JOIN P01_Oppose O ON R.Match_Id = O.Match_Id;
-- TEMPS D EXECUTION 13 ms
-- Produit cartesien
SELECT * FROM P01_Rencontre R, P01_Oppose O WHERE R.Match_Id = O.Match_Id;
-- TEMPS D EXECUTION 3 ms
-- On a la requete avec le produit cartesien est largement plus rapide que les autres.
-- 2) 2)
SELECT J.*, E.Equipe_Nom
FROM P01_Joueur J
NATURAL JOIN P01_Appartient A
NATURAL JOIN P01_Equipe E;
-- Temps d execution : 10ms
SELECT J.*, E.Equipe_Nom
FROM P01_Joueur J
INNER JOIN P01_Appartient A ON J.Joueur_Id = A.Joueur_Id
INNER JOIN P01_Equipe E ON A.Equipe_Id = E.Equipe_Id;
-- Temps d execution : 9ms
    SELECT J.*, E.Equipe_Nom
FROM P01_Joueur J
LEFT JOIN P01_Appartient A ON J.Joueur_Id = A.Joueur_Id
LEFT JOIN P01_Equipe E ON A.Equipe_Id = E.Equipe_Id;
-- Temps d execution : 9ms
    SELECT J.*, E.Equipe_Nom
FROM P01_Joueur J, P01_Appartient A, P01_Equipe E
WHERE J.Joueur_Id = A.Joueur_Id AND A.Equipe_Id = E.Equipe_Id;
-- Temps d execution : 5ms
-- 2) 3)
    SELECT J.Joueur_Id, J.Joueur_Nom, J.Joueur_Prenom, M.Match_Id
FROM P01_MatchJoueurStat M
INNER JOIN P01_Joueur J ON M.Joueur_Id = J.Joueur_Id
WHERE M.Essai > 0;
-- Temps d execution 6ms
    SELECT J.Joueur_Id, J.Joueur_Nom, J.Joueur_Prenom, M.Match_Id
FROM P01_MatchJoueurStat M
INNER JOIN P01_Joueur J ON M.Joueur_Id = J.Joueur_Id
WHERE M.Essai > 0;
-- Temps d execution 5ms
    SELECT J.Joueur_Id, J.Joueur_Nom, J.Joueur_Prenom, M.Match_Id
FROM P01_MatchJoueurStat M
LEFT JOIN P01_Joueur J ON M.Joueur_Id = J.Joueur_Id
WHERE M.Essai > 0;
-- Temps d execution 5ms
    SELECT J.Joueur_Id, J.Joueur_Nom, J.Joueur_Prenom, M.Match_Id
FROM P01_MatchJoueurStat M, P01_Joueur J
WHERE M.Joueur_Id = J.Joueur_Id AND M.Essai > 0;
-- temps d execution 5ms
    -- On remarque que le temps d execution des requetes est presque egaux.
-- 2) 4)
    SELECT * FROM P01_Rencontre NATURAL JOIN P01_MatchJoueurStat;
-- Temps d execution : 9ms
    SELECT * FROM P01_Rencontre R INNER JOIN P01_MatchJoueurStat M ON R.Match_Id = M.Match_Id;
-- Temps d execution : 8ms
    SELECT * FROM P01_Rencontre R LEFT JOIN P01_MatchJoueurStat M ON R.Match_Id = M.Match_Id;
-- Temps d execution : 8ms
SELECT * FROM P01_Rencontre R, P01_MatchJoueurStat M WHERE R.Match_Id = M.Match_Id;
-- Temps d execution 5ms
-- On a la requete avec le produit cartesien est plus rapide que les autres.
 -- 3 UNION , intersect, except
SELECT Equipe_Id, Equipe_Nom, Nb_Victoire, Nb_MatchNul, Nb_Defaite, NULL AS Joueur_Id, NULL AS Joueur_Nom
FROM P01_Equipe
UNION ALL
SELECT NULL, NULL, NULL, NULL, NULL, Joueur_Id, Joueur_Nom
FROM P01_Joueur;
-- EXCEPT
SELECT Equipe_Id, Equipe_Nom, Nb_Victoire, Nb_MatchNul, Nb_Defaite
FROM P01_Equipe
EXCEPT
SELECT Joueur_Id, Joueur_Nom, NULL::int, NULL::int, NULL::int
FROM P01_Joueur;
-- INTERSECT
SELECT Equipe_Nom FROM P01_Equipe
INTERSECT
SELECT Joueur_Nom FROM P01_Joueur;

-- SOUS REQUETE AVEC =
SELECT *
FROM P01_Equipe
WHERE Nb_Victoire = (SELECT MAX(Nb_Victoire) FROM P01_Equipe);
-- IN
SELECT *
FROM P01_Equipe
WHERE Equipe_Id IN (SELECT Equipe_Id FROM P01_Oppose WHERE Equipe_Id = 2);

-- SOUS REQUETE DANS LA CLAUSE FROM
SELECT e.Equipe_Id, e.Equipe_Nom, sub.TotalMatchs
FROM P01_Equipe e
JOIN (SELECT Equipe_Id, COUNT(*) AS TotalMatchs FROM P01_Oppose GROUP BY Equipe_Id) sub
ON e.Equipe_Id = sub.Equipe_Id;
-- SOUS REQUETE IMBRIQUE
SELECT Joueur_Id, Essai
FROM P01_MatchJoueurStat
WHERE Essai > (SELECT AVG(Essai) FROM P01_MatchJoueurStat);

-- SOUS REQUETE SYNCHRONISEE
SELECT *
FROM P01_Rencontre r
WHERE Score1 > (SELECT AVG(Score1) FROM P01_Rencontre);

-- SOUS REQUETE AVEC L OPERATEUR ANY
SELECT *
FROM P01_Equipe e
WHERE Nb_Victoire > ANY (SELECT Score2 FROM P01_Rencontre);
-- SOUS REQUETE AVEC L OPERATEUR ALL
SELECT Equipe_Id, Equipe_Nom, Nb_Victoire
FROM P01_Equipe
WHERE Nb_Victoire > ALL (
    SELECT Nb_Victoire
    FROM P01_Equipe
    WHERE Equipe_Nom LIKE 'A%'
);
-- 5 avec justification
-- avec jointure
SELECT DISTINCT J.Joueur_Id, J.Joueur_Nom, MJS.Essai
FROM P01_Joueur J
JOIN P01_MatchJoueurStat MJS ON J.Joueur_Id = MJS.Joueur_Id
JOIN P01_Rencontre R ON MJS.Match_Id = R.Match_Id
WHERE R.Score1 > (SELECT AVG(Score1) FROM P01_Rencontre);
-- avec sous requete
SELECT DISTINCT J.Joueur_Id, J.Joueur_Nom, MJS.Essai
FROM P01_Joueur J
JOIN P01_MatchJoueurStat MJS ON J.Joueur_Id = MJS.Joueur_Id
WHERE MJS.Match_Id IN (
    SELECT R.Match_Id
    FROM P01_Rencontre R
    WHERE R.Score1 > (SELECT AVG(Score1) FROM P01_Rencontre)
);
-- Justification sur l'efficacité :

    -- En général, la performance entre une jointure et une sous-requête dépend de plusieurs facteurs, y compris la taille des tables, l'indexation, et la manière dont le moteur de base de données optimise la requête.

    -- Jointure : Les bases de données modernes sont souvent optimisées pour gérer efficacement les jointures. Si les tables sont correctement indexées, une jointure peut être très efficace.

    --  Sous-requête : Les sous-requêtes peuvent être moins efficaces, en particulier si elles renvoient un grand ensemble de résultats ou si elles sont imbriquées. Cependant, dans certains cas, une sous-requête peut être plus lisible et plus facile à comprendre.
-- GROUP BY
SELECT Equipe_Id, Equipe_Nom, SUM(Nb_Victoire) AS TotalVictoires
FROM P01_Equipe
GROUP BY Equipe_Id, Equipe_Nom;
-- avec sous requete
SELECT Equipe_Id, Equipe_Nom,
  (SELECT SUM(Nb_Victoire) FROM P01_Equipe E2 WHERE E2.Equipe_Id = P01_Equipe.Equipe_Id) AS TotalVictoires
FROM P01_Equipe;
--COUNT
SELECT COUNT(*) AS TotalMatches
FROM P01_Rencontre;
-- SUM
SELECT SUM(Score1 + Score2) AS TotalScore
FROM P01_Rencontre;
-- 7
SELECT Equipe_Id, Equipe_Nom,
       SUM(Nb_Victoire) AS TotalVictoires,
       SUM(Nb_Defaite) AS TotalDefaites
FROM P01_Equipe
GROUP BY Equipe_Id, Equipe_Nom;

-- GROUP BY ET HAVING
SELECT Equipe_Id, Equipe_Nom,
       SUM(Nb_Victoire) AS TotalVictoires,
       SUM(Nb_Defaite) AS TotalDefaites
FROM P01_Equipe
GROUP BY Equipe_Id, Equipe_Nom
HAVING SUM(Nb_Victoire) > 5;

-- 8
-- Exemple 1 - Utilisation de HAVING pour filtrer sur la somme des valeurs agrégées
SELECT Equipe_Id, Equipe_Nom,
       SUM(Nb_Victoire) AS TotalVictoires
FROM P01_Equipe
GROUP BY Equipe_Id, Equipe_Nom
HAVING SUM(Nb_Victoire) > 2;

-- Exemple 2 - Utilisation de HAVING avec COUNT pour filtrer sur le nombre de membres d'une équipe
SELECT e.Equipe_Id, e.Equipe_Nom,
       COUNT(a.Joueur_Id) AS NombreMembres
FROM P01_Equipe e
JOIN P01_Appartient a ON e.Equipe_Id = a.Equipe_Id
GROUP BY e.Equipe_Id, e.Equipe_Nom
HAVING COUNT(a.Joueur_Id) > 20;

-- 9
-- Exemple de requête avec auto-jointure (self-join) sur la table 'P01_Joueur'
SELECT J1.Joueur_Id AS Joueur1_Id, J1.Joueur_Nom AS Joueur1_Nom, J1.Joueur_Prenom AS Joueur1_Prenom,
       J2.Joueur_Id AS Joueur2_Id, J2.Joueur_Nom AS Joueur2_Nom, J2.Joueur_Prenom AS Joueur2_Prenom
FROM P01_Joueur J1
JOIN P01_Joueur J2 ON J1.Equipe_Id = J2.Equipe_Id AND J1.Joueur_Id <> J2.Joueur_Id;
