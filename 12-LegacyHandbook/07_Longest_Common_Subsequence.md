# Longest Common Subsequence $(LCS)$:
LCS encuentra la subsecuencia común más larga entre dos secuencias mediante programación dinámica con complejidad $O(nm)$. La relación de recurrencia establece que $LCS[i][j] = LCS[i-1][j-1] + 1$ si los caracteres coinciden, o $max(LCS[i-1][j], LCS[i][j-1])$ en caso contrario. Esta técnica tiene aplicaciones en bioinformática para alineamiento de secuencias, control de versiones y detección de similitud textual.

```cpp
string findLCS(const string& X, const string& Y) {
    int m = X.length();
    int n = Y.length();

    vector<vector<int>> dp(m + 1, vector<int>(n + 1, 0));

    for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= n; j++) {
            if (X[i - 1] == Y[j - 1]) {
                dp[i][j] = dp[i - 1][j - 1] + 1;
            } else {
                dp[i][j] = max(dp[i - 1][j], dp[i][j - 1]);
            }
        }
    }

    int lcs_length = dp[m][n];
    string lcs(lcs_length, ' ');

    int i = m, j = n;
    while (i > 0 && j > 0) {
        if (X[i - 1] == Y[j - 1]) {
            lcs[--lcs_length] = X[i - 1];
            i--;
            j--;
        } else if (dp[i - 1][j] > dp[i][j - 1]) {
            i--;
        } else {
            j--;
        }
    }

    return lcs;
}
```