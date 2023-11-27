--1

SELECT * FROM P01_Equipe WHERE REGEXP_LIKE(Equipe_Nom, '^A');
-- L'opérateur REGEXP_LIKE permet de filtrer les données de la table P01_Equipe en sélectionnant uniquement les lignes où le champ Equipe_Nom commence par la lettre 'A'.


-- 2
-- 1. Jointure interne entre P01_Rencontre et P01_Oppose :
-- Syntaxe 1
SELECT *
FROM P01_Rencontre
NATURAL JOIN P01_Oppose;
-- Temps d execution 5ms
-- Syntaxe 2
SELECT *
FROM P01_Rencontre R
INNER JOIN P01_Oppose O ON R.Match_Id = O.Match_Id;
-- Temps d execution 7ms
-- Jointure externe alternative
SELECT *
FROM P01_Rencontre R
LEFT JOIN P01_Oppose O ON R.Match_Id = O.Match_Id;
-- Temps d execution 7ms
-- Produit cartésien avec restriction
SELECT *
FROM P01_Rencontre R, P01_Oppose O
WHERE R.Match_Id = O.Match_Id;
-- Temps d execution 3ms
    -- On a la requete du produit cartesien se compile rapidement que les autres

-- 2. Les joueurs avec leurs équipes, poste, numéro de maillot :
-- Syntaxe 1
SELECT J.*, E.Equipe_Nom
FROM P01_Joueur J
JOIN P01_Appartient A ON J.Joueur_Id = A.Joueur_Id
JOIN P01_Equipe E ON A.Equipe_Id = E.Equipe_Id;
-- Temps d execution 18ms

-- Syntaxe 2
SELECT J.*, E.Equipe_Nom
FROM P01_Joueur J
INNER JOIN P01_Appartient A ON J.Joueur_Id = A.Joueur_Id
INNER JOIN P01_Equipe E ON A.Equipe_Id = E.Equipe_Id;
-- Temps d execution 19ms
-- Jointure externe alternative
SELECT J.*, E.Equipe_Nom
FROM P01_Joueur J
LEFT JOIN P01_Appartient A ON J.Joueur_Id = A.Joueur_Id
LEFT JOIN P01_Equipe E ON A.Equipe_Id = E.Equipe_Id;
-- Temps d execution 19ms
-- Produit cartésien avec restriction
SELECT J.*, E.Equipe_Nom
FROM P01_Joueur J, P01_Appartient A, P01_Equipe E
WHERE J.Joueur_Id = A.Joueur_Id AND A.Equipe_Id = E.Equipe_Id;
-- Temps d execution 17ms
-- On a la derniere requete s execute rapidement que les autres

-- 3. Jointure interne entre P01_MatchJoueurStat et P01_Joueur :
-- Joueurs qui ont marqué un essai ou plus
SELECT Joueur_Id, Joueur_Nom, Joueur_Prenom, Match_Id
FROM P01_MatchJoueurStat
NATURAL JOIN P01_Joueur
WHERE Essai > 0;
-- Temps d execution 15ms
-- ou

SELECT J.Joueur_Id, J.Joueur_Nom, J.Joueur_Prenom, M.Match_Id
FROM P01_MatchJoueurStat M
INNER JOIN P01_Joueur J ON M.Joueur_Id = J.Joueur_Id
WHERE M.Essai > 0;
-- Temps d execution 16ms

-- b) Version alternative avec une jointure externe :



SELECT J.Joueur_Id, J.Joueur_Nom, J.Joueur_Prenom, M.Match_Id
FROM P01_MatchJoueurStat M
LEFT JOIN P01_Joueur J ON M.Joueur_Id = J.Joueur_Id
WHERE M.Essai > 0;
-- Temps d execution 14ms

-- c) Version basée sur le produit cartésien avec une restriction de jointure :



SELECT J.Joueur_Id, J.Joueur_Nom, J.Joueur_Prenom, M.Match_Id
FROM P01_MatchJoueurStat M, P01_Joueur J
WHERE M.Joueur_Id = J.Joueur_Id AND M.Essai > 0;
-- Temps d execution 3ms

-- 4 Jointure interne entre P01_Rencontre et P01_MatchJoueurStat :

-- a) Syntaxes différentes :

SELECT *
FROM P01_Rencontre
NATURAL JOIN P01_MatchJoueurStat;
-- Temps d execution 6ms

-- ou

SELECT *
FROM P01_Rencontre R
INNER JOIN P01_MatchJoueurStat M ON R.Match_Id = M.Match_Id;
-- Temps d execution 5ms

-- b) Version alternative avec une jointure externe :



SELECT *
FROM P01_Rencontre R
LEFT JOIN P01_MatchJoueurStat M ON R.Match_Id = M.Match_Id;
-- Temps d execution 4ms

-- c) Version basée sur le produit cartésien avec une restriction de jointure :



SELECT *
FROM P01_Rencontre R, P01_MatchJoueurStat M
WHERE R.Match_Id = M.Match_Id;
-- Temps d execution 3ms
-- Comme les exemples precedents la requetes avec le produit cartesien s execute plus rapidement que les autres
    --Mais on peut remarquer qu il y a pas une tres grande difference au niveau du temps d execution

--3
-- UNION
SELECT Equipe_Id, Equipe_Nom, Nb_Victoire, Nb_MatchNul, Nb_Defaite
FROM P01_Equipe
UNION
SELECT Joueur_Id, Joueur_Nom, NULL, NULL, NULL
FROM P01_Joueur;

-- INTERSECT
SELECT Equipe_Nom FROM P01_Equipe
INTERSECT
SELECT Joueur_Nom FROM P01_Joueur;

-- EXCEPT (utilisant MINUS car Oracle ne prend pas en charge directement EXCEPT)
SELECT Equipe_Id, Equipe_Nom, Nb_Victoire, Nb_MatchNul, Nb_Defaite
FROM P01_Equipe
MINUS
SELECT Joueur_Id, Joueur_Nom, NULL, NULL, NULL
FROM P01_Joueur;


--4
-- a) Sous-requête avec l'opérateur =

SELECT *
FROM P01_Equipe
WHERE Nb_Victoire = (SELECT MAX(Nb_Victoire) FROM P01_Equipe);
-- b) Sous-requête avec l'opérateur IN

SELECT *
FROM P01_Equipe
WHERE Equipe_Id IN (SELECT Equipe_Id FROM P01_Oppose WHERE Equipe_Id = 2);
-- c) Sous-requête dans la clause FROM

SELECT e.Equipe_Id, e.Equipe_Nom, sub.TotalMatchs
FROM P01_Equipe e
JOIN (
    SELECT Equipe_Id, COUNT(*) AS TotalMatchs
    FROM P01_Oppose
    GROUP BY Equipe_Id
) sub
ON e.Equipe_Id = sub.Equipe_Id;
-- d) Sous-requête imbriquée

SELECT Joueur_Id, Essai
FROM P01_MatchJoueurStat
WHERE Essai > (SELECT AVG(Essai) FROM P01_MatchJoueurStat);
-- e) Sous-requête synchronisée

SELECT *
FROM P01_Rencontre r
WHERE Score1 > (SELECT AVG(Score1) FROM P01_Rencontre);
-- f) Sous-requête avec l'opérateur ANY

SELECT *
FROM P01_Equipe e
WHERE Nb_Victoire > ANY (SELECT Score2 FROM P01_Rencontre);
-- g) Sous-requête avec l'opérateur ALL

SELECT Equipe_Id, Equipe_Nom, Nb_Victoire
FROM P01_Equipe
WHERE Nb_Victoire > ALL (
    SELECT Nb_Victoire
    FROM P01_Equipe
    WHERE Equipe_Nom LIKE 'A%'
);

--5

-- Voici les deux versions de la requête en utilisant Oracle, avec une jointure et avec une sous-requête :
   -- 1. Requête avec jointure :

SELECT DISTINCT J.Joueur_Id, J.Joueur_Nom, MJS.Essai
FROM P01_Joueur J
JOIN P01_MatchJoueurStat MJS ON J.Joueur_Id = MJS.Joueur_Id
JOIN P01_Rencontre R ON MJS.Match_Id = R.Match_Id
WHERE R.Score1 > (SELECT AVG(Score1) FROM P01_Rencontre);
    -- 2. Requête avec sous-requête :

SELECT DISTINCT J.Joueur_Id, J.Joueur_Nom, MJS.Essai
FROM P01_Joueur J
JOIN P01_MatchJoueurStat MJS ON J.Joueur_Id = MJS.Joueur_Id
WHERE MJS.Match_Id IN (
    SELECT R.Match_Id
    FROM P01_Rencontre R
    WHERE R.Score1 > (SELECT AVG(Score1) FROM P01_Rencontre)
);
-- Justification :
-- La performance entre une jointure et une sous-requête peut dépendre de plusieurs facteurs, tels que la taille des tables, les index disponibles, et les statistiques de la base de données.
-- En général, la version utilisant la jointure pourrait être plus efficace, car les bases de données modernes, 
-- y compris Oracle, sont optimisées pour traiter efficacement les jointures. Les optimiseurs de requêtes peuvent choisir le meilleur plan d'exécution pour les jointures, 
-- en utilisant des index et d'autres techniques pour minimiser le coût de la requête.
-- Dans la plupart des cas, l'utilisation de jointures est privilégiée car elle permet au SGBD d'optimiser l'accès aux données. Cependant, 
-- l'efficacité réelle doit être vérifiée en examinant les plans d'exécution spécifiques à la base de données.

--6
     -- 1.Requête avec GROUP BY en Oracle :

-- Requête avec GROUP BY en Oracle
SELECT Equipe_Id, Equipe_Nom, SUM(Nb_Victoire) AS TotalVictoires
FROM P01_Equipe
GROUP BY Equipe_Id, Equipe_Nom;
    -- 2. Requête avec une sous-requête en Oracle :

-- Requête avec une sous-requête en Oracle
SELECT Equipe_Id, Equipe_Nom,
  (SELECT SUM(Nb_Victoire) FROM P01_Equipe E2 WHERE E2.Equipe_Id = P01_Equipe.Equipe_Id) AS TotalVictoires
FROM P01_Equipe;


-- Requête avec COUNT en Oracle
SELECT COUNT(*) AS TotalMatches
FROM P01_Rencontre;

-- Requête avec SUM en Oracle
SELECT SUM(Score1 + Score2) AS TotalScore
FROM P01_Rencontre;

-- 7
-- Requête avec GROUP BY :

-- Requête avec GROUP BY
SELECT Equipe_Id, Equipe_Nom,
       SUM(Nb_Victoire) AS TotalVictoires,
       SUM(Nb_Defaite) AS TotalDefaites
FROM P01_Equipe
GROUP BY Equipe_Id, Equipe_Nom;
--Cette requête rassemble des informations sur le total des victoires et des défaites pour chaque équipe de la table P01_Equipe en utilisant la clause GROUP BY.
  --  2. Requête avec GROUP BY et HAVING :

-- Requête avec GROUP BY et HAVING
SELECT Equipe_Id, Equipe_Nom,
       SUM(Nb_Victoire) AS TotalVictoires,
       SUM(Nb_Defaite) AS TotalDefaites
FROM P01_Equipe
GROUP BY Equipe_Id, Equipe_Nom
HAVING SUM(Nb_Victoire) > 5;-- Exemple de condition HAVING
-- Cette requête rassemble des informations similaires à la première requête, mais elle utilise également la clause HAVING pour filtrer les résultats, ne montrant que les équipes avec plus de 5 victoires.

--8

-- Exemple 1 - Utilisation de HAVING pour filtrer sur la somme des valeurs agrégées
SELECT Equipe_Id, Equipe_Nom,
       SUM(Nb_Victoire) AS TotalVictoires
FROM P01_Equipe
GROUP BY Equipe_Id, Equipe_Nom
HAVING SUM(Nb_Victoire) > 2;
-- Cette requête rassemble des informations sur le total des victoires pour chaque équipe de la table P01_Equipe en utilisant la clause GROUP BY. 
-- La clause HAVING est ensuite utilisée pour filtrer les résultats, ne montrant que les équipes avec un total de victoires supérieur à 2.
-- Exemple 2  Utilisation de HAVING avec COUNT pour filtrer sur le nombre de membres d une équipe
SELECT e.Equipe_Id, e.Equipe_Nom,
       COUNT(a.Joueur_Id) AS NombreMembres
FROM P01_Equipe e
JOIN P01_Appartient a ON e.Equipe_Id = a.Equipe_Id
GROUP BY e.Equipe_Id, e.Equipe_Nom
HAVING COUNT(a.Joueur_Id) > 20;
-- Cette requête rassemble des informations sur le nombre de membres de chaque équipe de la table P01_Equipe en utilisant la clause GROUP BY. 
-- La clause HAVING est ensuite utilisée pour filtrer les résultats, ne montrant que les équipes avec plus de 20 membres.

--9

-- Exemple de requête avec auto-jointure (self-join) sur la table 'P01_Joueur' en Oracle
SELECT J1.Joueur_Id AS Joueur1_Id, J1.Joueur_Nom AS Joueur1_Nom, J1.Joueur_Prenom AS Joueur1_Prenom,
       J2.Joueur_Id AS Joueur2_Id, J2.Joueur_Nom AS Joueur2_Nom, J2.Joueur_Prenom AS Joueur2_Prenom
FROM P01_Joueur J1
JOIN P01_Joueur J2 ON J1.Equipe_Id = J2.Equipe_Id AND J1.Joueur_Id <> J2.Joueur_Id;
-- Cette requête utilise une auto-jointure sur la table 'P01_Joueur' en créant deux alias de table, J1 et J2.
-- Elle sélectionne des informations de deux joueurs différents (Joueur1 et Joueur2) qui appartiennent à la même équipe, en s'assurant que le joueur1 et le joueur2 sont différents (J1.Joueur_Id <> J2.Joueur_Id). 
-- Ainsi, la requête rassemble les informations de deux joueurs différents, mais de la même équipe, sur une même ligne.