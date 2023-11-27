-- MySQL
-- 1
SELECT * FROM P01_Equipe WHERE Equipe_Nom REGEXP '^A';


-- 2

-- 1) jointure interne entre P01_Rencontre et P01_Oppose
-- pour obtenir les dÃ©tails des matchs avec les Ã©quipes impliquÃ©es
SELECT *
FROM P01_Rencontre
NATURAL JOIN P01_Oppose;

-- Deux syntaxes diffÃ©rentes pour la mÃªme requÃªte :
SELECT *
FROM P01_Rencontre
NATURAL JOIN P01_Oppose;
-- Temps d execution 33ms
-- jointure interne explicite
SELECT *
FROM P01_Rencontre R
INNER JOIN P01_Oppose O ON R.Match_Id = O.Match_Id;
-- Temps d execution 23ms

-- Version alternative mettant en Å“uvre une jointure externe :
SELECT *
FROM P01_Rencontre R
LEFT JOIN P01_Oppose O ON R.Match_Id = O.Match_Id;
-- Temps d execution 15ms


-- P01_Rencontre est la table de gauche de la jointure.
-- P01_Oppose est la table de droite de la jointure.
    -- pour les lignes où les les Match_Id de la table gauche et droite sont egaux.
-- LEFT JOIN permet de récupérer toutes les lignes de la table de gauche et les enregistrements correspondants de la table de droite
-- s'il y a des correspondances
-- Si aucune correspondance n'est trouvée pour un enregistrement de la table de gauche,
-- les colonnes de la table de droite seront NULL dans le résultat.

-- Version basÃ©e sur le produit cartÃ©sien avec une restriction de jointure :
SELECT *
FROM P01_Rencontre R, P01_Oppose O
WHERE R.Match_Id = O.Match_Id;
    -- On a la derniere version est la plus rapide car meme si c est du produit cartesien
-- on a la condition qu'on doit avoir le meme Match_Id dans les deux tables


-- 2) Les joueurs avec leurs equipes , poste, numero maillot
SELECT J.*, E.Equipe_Nom
FROM P01_Joueur J
NATURAL JOIN P01_Appartient
NATURAL JOIN P01_Equipe E;

-- les deux syntaxes
    SELECT J.*, E.Equipe_Nom
FROM P01_Joueur J
NATURAL JOIN P01_Appartient
NATURAL JOIN P01_Equipe E;
-- Temps d execution 17ms

SELECT J.*, E.Equipe_Nom
FROM P01_Joueur J
INNER JOIN P01_Appartient A ON J.Joueur_Id = A.Joueur_Id
INNER JOIN P01_Equipe E ON A.Equipe_Id = E.Equipe_Id;
-- Temps d execution 17 ms
-- Version alternative mettant en Å“uvre une jointure externe :
    SELECT J.*, E.Equipe_Nom
FROM P01_Joueur J
LEFT JOIN P01_Appartient A ON J.Joueur_Id = A.Joueur_Id
LEFT JOIN P01_Equipe E ON A.Equipe_Id = E.Equipe_Id;
-- Temps d execution 28 ms

-- P01_Joueur est la table de gauche de la jointure.
-- P01_Appartient, P01_Equipe sont les tables de droite de la jointure.
-- LEFT JOIN permet de récupérer toutes les lignes de la table de gauche et les enregistrements correspondants de la table de droite
-- s'il y a des correspondances
-- Si aucune correspondance n'est trouvée pour un enregistrement de la table de gauche,
-- les colonnes de la table de droite seront NULL dans le résultat.

-- Version basÃ©e sur le produit cartÃ©sien avec une restriction de jointure :
    SELECT J.*, E.Equipe_Nom
FROM P01_Joueur J, P01_Appartient A, P01_Equipe E
WHERE J.Joueur_Id = A.Joueur_Id AND A.Equipe_Id = E.Equipe_Id;
-- Temps d execution 16ms
    -- On a la version du produit cartesien est plus rapide que les autres.

-- 3) Jointure interne entre P01_MatchJoueurStat et P01_Joueur
-- pour obtenir Joueur_Id,Joueur_Nom,Joueur_Prenom et Match_Id
-- tous les joueurs qui ont marquÃ© un essai ou plus.
SELECT
  Joueur_Id,
  Joueur_Nom,
  Joueur_Prenom,
  Match_Id
FROM
  P01_MatchJoueurStat NATURAL JOIN P01_Joueur
WHERE
  Essai > 0;
-- Les deux syntaxes :
    -- La 1er
    SELECT Joueur_Id, Joueur_Nom, Joueur_Prenom, Match_Id
FROM P01_MatchJoueurStat
NATURAL JOIN P01_Joueur
WHERE Essai > 0;
-- Temps dexecution 19ms
-- La 2eme syntaxe :
    SELECT J.Joueur_Id, J.Joueur_Nom, J.Joueur_Prenom, M.Match_Id
FROM P01_MatchJoueurStat M
INNER JOIN P01_Joueur J ON M.Joueur_Id = J.Joueur_Id
WHERE M.Essai > 0;
-- Temps dexecution 17ms

-- Version alternative mettant en Å“uvre une jointure externe :
    SELECT J.Joueur_Id, J.Joueur_Nom, J.Joueur_Prenom, M.Match_Id
FROM P01_MatchJoueurStat M
LEFT JOIN P01_Joueur J ON M.Joueur_Id = J.Joueur_Id
WHERE M.Essai > 0;
-- Temps d execution 10ms

-- P01_MatchJoueurStat est la table de gauche de la jointure.
-- P01_Joueur est la table de droite de la jointure.
-- LEFT JOIN permet de récupérer toutes les lignes de la table de gauche et les enregistrements correspondants de la table de droite
-- s'il y a des correspondances
-- Si aucune correspondance n'est trouvée pour un enregistrement de la table de gauche,
-- les colonnes de la table de droite seront NULL dans le résultat.

-- Version basÃ©e sur le produit cartÃ©sien avec une restriction de jointure :
    SELECT J.Joueur_Id, J.Joueur_Nom, J.Joueur_Prenom, M.Match_Id
FROM P01_MatchJoueurStat M, P01_Joueur J
WHERE M.Joueur_Id = J.Joueur_Id AND M.Essai > 0;
-- Temps d execution 9ms
    -- On a la version du produit cartesien est plus rapide que les autres.


-- 3) Jointure interne entre P01_Rencontre et P01_MatchJoueurStat
-- pour afficher les statistiques des joueurs pour chaque match
SELECT *
FROM P01_Rencontre
NATURAL JOIN P01_MatchJoueurStat;

-- Les deux syntaxes :
-- 1er :
SELECT *
FROM P01_Rencontre
NATURAL JOIN P01_MatchJoueurStat;
-- Temps d execution 9 ms

-- 2eme syntaxe :
SELECT *
FROM P01_Rencontre R
INNER JOIN P01_MatchJoueurStat M ON R.Match_Id = M.Match_Id;
-- Temps d execution 16ms

-- Version alternative mettant en Å“uvre une jointure externe :
SELECT *
FROM P01_Rencontre R
LEFT JOIN P01_MatchJoueurStat M ON R.Match_Id = M.Match_Id;
-- Temps d execution 10ms

-- P01_Rencontre est la table de gauche de la jointure.
-- P01_MatchJoueurStat est la table de droite de la jointure.
-- LEFT JOIN permet de récupérer toutes les lignes de la table de gauche et les enregistrements correspondants de la table de droite
-- s'il y a des correspondances
-- Si aucune correspondance n'est trouvée pour un enregistrement de la table de gauche,
-- les colonnes de la table de droite seront NULL dans le résultat.

-- Version basÃ©e sur le produit cartÃ©sien avec une restriction de jointure :
SELECT *
FROM P01_Rencontre R, P01_MatchJoueurStat M
WHERE R.Match_Id = M.Match_Id;
-- Temps d execution 8ms

    -- On a d apres ce qui precede (les temps d executions) on trouve que la requete du produit cartesien
-- associée à une restriction réalisant la condition de jointure est plus rapide.





-- 3
-- Donner une requête pour chacun des opérateurs ensemblistes (UNION, INSERSECT et EXCEPT)
    -- INTERSECT et Except ne sont pas supporté par MySQL

-- Sélectionnez toutes les équipes de la table P01_Equipe et tous les joueurs de la table P01_Joueur
SELECT Equipe_Id, Equipe_Nom, Nb_Victoire, Nb_MatchNul, Nb_Defaite
FROM P01_Equipe
UNION
SELECT Joueur_Id, Joueur_Nom, NULL, NULL, NULL
FROM P01_Joueur;

-- Opérateur INTERSECT
-- SA VERSION AVEC INNER JOIN

SELECT DISTINCT P01_Equipe.Equipe_Nom
FROM P01_Equipe
INNER JOIN P01_Joueur ON P01_Equipe.Equipe_Id = P01_Joueur.Equipe_Id;


-- Opérateur EXCEPT

-- VERSION MYSQL
SELECT Equipe_Id, Equipe_Nom, Nb_Victoire, Nb_MatchNul, Nb_Defaite
FROM P01_Equipe
WHERE Equipe_Id NOT IN (SELECT Equipe_Id FROM P01_Joueur);

-- 4
-- a) Sous-requête avec l'opérateur =
SELECT *
FROM P01_Equipe
WHERE Nb_Victoire = (SELECT MAX(Nb_Victoire) FROM P01_Equipe);



-- b) Sous-requête avec l'opérateur IN
SELECT *
FROM P01_Equipe
WHERE Equipe_Id IN (SELECT Equipe_Id FROM P01_Oppose WHERE Equipe_Id = 2);

-- c) Sous-requête dans la clause FROM
SELECT e.Equipe_Id, e.Equipe_Nom, TotalMatchs
FROM P01_Equipe e
JOIN (SELECT Equipe_Id, COUNT(*) AS TotalMatchs FROM P01_Oppose GROUP BY Equipe_Id) sub
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
-- Sous-requête avec l'opérateur ALL
SELECT Equipe_Id, Equipe_Nom, Nb_Victoire
FROM P01_Equipe
WHERE Nb_Victoire > ALL (
    SELECT Nb_Victoire
    FROM P01_Equipe
    WHERE Equipe_Nom LIKE 'A%'
);



-- 5 avec justification

-- Requête avec jointure
SELECT DISTINCT J.Joueur_Id, J.Joueur_Nom, MJS.Essai
FROM P01_Joueur J
JOIN P01_MatchJoueurStat MJS ON J.Joueur_Id = MJS.Joueur_Id
JOIN P01_Rencontre R ON MJS.Match_Id = R.Match_Id
WHERE R.Score1 > (SELECT AVG(Score1) FROM P01_Rencontre);

-- Requête avec sous-requête
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

-- 6  / 1 exemple
-- Requête avec GROUP BY
SELECT Equipe_Id, Equipe_Nom, SUM(Nb_Victoire) AS TotalVictoires
FROM P01_Equipe
GROUP BY Equipe_Id, Equipe_Nom;


-- Requête avec une sous-requête
SELECT Equipe_Id, Equipe_Nom,
  (SELECT SUM(Nb_Victoire) FROM P01_Equipe E2 WHERE E2.Equipe_Id = P01_Equipe.Equipe_Id) AS TotalVictoires
FROM P01_Equipe;



-- 6
-- Utilisation de COUNT
SELECT COUNT(*) AS TotalMatches
FROM P01_Rencontre;


-- Utilisation de SUM
SELECT SUM(Score1 + Score2) AS TotalScore
FROM P01_Rencontre;




-- 7
-- Requête avec GROUP BY
SELECT Equipe_Id, Equipe_Nom,
       SUM(Nb_Victoire) AS TotalVictoires,
       SUM(Nb_Defaite) AS TotalDefaites
FROM P01_Equipe
GROUP BY Equipe_Id, Equipe_Nom;


-- Requête avec GROUP BY et HAVING
SELECT Equipe_Id, Equipe_Nom,
       SUM(Nb_Victoire) AS TotalVictoires,
       SUM(Nb_Defaite) AS TotalDefaites
FROM P01_Equipe
GROUP BY Equipe_Id, Equipe_Nom
HAVING TotalVictoires > 5; -- Exemple de condition HAVING

-- 8
-- Exemple 1 - Utilisation de HAVING pour filtrer sur la somme des valeurs agrégées
SELECT Equipe_Id, Equipe_Nom,
       SUM(Nb_Victoire) AS TotalVictoires
FROM P01_Equipe
GROUP BY Equipe_Id, Equipe_Nom
HAVING TotalVictoires > 2;



-- Exemple 2 - Utilisation de HAVING avec COUNT pour filtrer sur le nombre de membres d'une équipe
SELECT e.Equipe_Id, e.Equipe_Nom,
       COUNT(a.Joueur_Id) AS NombreMembres
FROM P01_Equipe e
JOIN P01_Appartient a ON e.Equipe_Id = a.Equipe_Id
GROUP BY e.Equipe_Id, e.Equipe_Nom
HAVING NombreMembres > 20;


-- 9
-- Exemple de requête avec auto-jointure (self-join) sur la table 'P01_Joueur'
SELECT J1.Joueur_Id AS Joueur1_Id, J1.Joueur_Nom AS Joueur1_Nom, J1.Joueur_Prenom AS Joueur1_Prenom,
       J2.Joueur_Id AS Joueur2_Id, J2.Joueur_Nom AS Joueur2_Nom, J2.Joueur_Prenom AS Joueur2_Prenom
FROM P01_Joueur J1
JOIN P01_Joueur J2 ON J1.Equipe_Id = J2.Equipe_Id AND J1.Joueur_Id <> J2.Joueur_Id;

