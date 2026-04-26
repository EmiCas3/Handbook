# Trie

```cpp
#define ALPH 26

struct Trie
{
    vvi nxt
    vb end

    Trie()
    {
        nxt.push_back(vi(ALPH,-1))
        end.push_back(false)
    }

    void insert(string s)
    {
        int u=0
        for(char c:s)
        {
            int i=c-'a'
            if(nxt[u][i]==-1)
            {
                nxt[u][i]=nxt.size()
                nxt.push_back(vi(ALPH,-1))
                end.push_back(false)
            }
            u=nxt[u][i]
        }
        end[u]=true
    }

    bool find(string s)
    {
        int u=0
        for(char c:s)
        {
            int i=c-'a'
            if(nxt[u][i]==-1) return false
            u=nxt[u][i]
        }
        return end[u]
    }

    void erase(string s)
    {
        function<bool(int,int)> del=[&](int u,int d)
        {
            if(u==-1) return true
            if(d==s.size()) end[u]=false
            else
            {
                int i=s[d]-'a'
                if(del(nxt[u][i],d+1)) nxt[u][i]=-1
            }
            bool empty=true
            forn(i,ALPH) if(nxt[u][i]!=-1) empty=false
            return !end[u] && empty
        }
        del(0,0)
    }

    void print()
    {
        string cur
        function<void(int)> dfs=[&](int u)
        {
            if(end[u]) cout<<cur<<endl
            forn(i,ALPH)
            {
                if(nxt[u][i]!=-1)
                {
                    cur.push_back('a'+i)
                    dfs(nxt[u][i])
                    cur.pop_back()
                }
            }
        }
        dfs(0)
    }

    void clear()
    {
        nxt.assign(1,vi(ALPH,-1))
        end.assign(1,false)
    }
}
```

