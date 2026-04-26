# Arboles

```cpp
struct Tree
 {
  int n, LOG, timer=0;
  vvi g, up;
  vi depth, parent, tin, tout;

  Tree(const vvi &adj, int root=0) 
  {
    g=adj; n=g.size();
    depth.assign(n,0); parent.assign(n,-1);
    tin.assign(n,0); tout.assign(n,0);
    LOG=1; while((1<<LOG)<=n) LOG++;
    up.assign(n,vi(LOG,-1));
    dfs(root); build_lift();
  }

  void dfs(int u,int p=-1)
  {
    tin[u]=++timer; parent[u]=p;
    if(p!=-1) depth[u]=depth[p]+1;
    for(int v:g[u]) if(v!=p) dfs(v,u);
    tout[u]=++timer;
  }

  void build_lift()
  {
    forn(i,n) up[i][0]=(parent[i]==-1?i:parent[i]);
    for(int j=1;j<LOG;j++) forn(i,n)
      up[i][j]=up[up[i][j-1]][j-1];
  }
};
```


## Binary Tree Traversals

Recorridos clásicos de árbol: preorden, inorden y postorden.

```cpp
void preorder(Tree &t,int u,int p=-1)
{
  cout<<u<<" ";
  for(int v:t.g[u]) if(v!=p) preorder(t,v,u);
}

void inorder(Tree &t,int u,int p=-1)
{
  if(t.g[u].empty()){ cout<<u<<" "; return; }
  bool first=true;
  for(int v:t.g[u]) if(v!=p){
    if(first){ inorder(t,v,u); first=false; }
    else cout<<u<<" ", inorder(t,v,u);
  }
  if(first) cout<<u<<" ";
}

void postorder(Tree &t,int u,int p=-1)
{
  for(int v:t.g[u]) if(v!=p) postorder(t,v,u);
  cout<<u<<" ";
}

// Uso:
int main()
{
  vvi g={{1,2},{0,3,4},{0},{1},{1}}; 
  Tree t(g);
  cout<<"Preorder: "; preorder(t,0); cout<<"\n";
  cout<<"Inorder: "; inorder(t,0); cout<<"\n";
  cout<<"Postorder: "; postorder(t,0); cout<<"\n";
}
```
$\clearpage$
# Calculating Tree Diameter

Usa dos DFS para obtener el diámetro del árbol (camino más largo entre dos nodos) en O(n).

```cpp
int tree_diameter(Tree &t)
{
  function<pair<int,int>(int,int)> farthest=[&](int u,int p)
  {
    pair<int,int> best={0,u};
    for(int v:t.g[u]) if(v!=p)
    {
      auto cur=farthest(v,u);
      cur.first++;
      best=max(best,cur);
    }
    return best;
  };
  auto a=farthest(0,-1);
  auto b=farthest(a.second,-1);
  return b.first;
}

int main()
{
  vvi g={{1},{0,2,3},{1},{1,4},{3}};
  Tree t(g);
  cout<<"Diameter: "<<tree_diameter(t)<<"\n";
}
```
$\clearpage$
## All longest paths

Calcula para cada nodo la distancia máxima a cualquier otro nodo (reroot DP clásico). Complejidad O(n).

```cpp
vi all_longest_path(Tree &t)
{
  vi max1(t.n),max2(t.n),up(t.n);

  function<void(int,int)> dfs_down=[&](int s,int p)
  {
    max1[s]=max2[s]=0;
    for(int u:t.g[s]) if(u!=p)
    {
      dfs_down(u,s);
      int len=max1[u]+1;
      if(len>max1[s]) swap(len,max1[s]);
      if(len>max2[s]) max2[s]=len;
    }
  };

  function<void(int,int)> dfs_up=[&](int s,int p)
  {
    for(int u:t.g[s]) if(u!=p)
    {
      if(max1[u]+1==max1[s]) up[u]=max(up[s],max2[s])+1;
      else up[u]=max(up[s],max1[s])+1;
      dfs_up(u,s);
    }
  };

  dfs_down(0,-1); up[0]=0; dfs_up(0,-1);
  vi ans(t.n);
  forn(i,t.n) ans[i]=max(max1[i],up[i]);
  return ans;
}

int main(){
  vvi g={{1,2},{0,3,4},{0},{1},{1}};
  Tree t(g);
  vi d=all_longest_path(t);
  forn(i,t.n) cout<<"Longest from "<<i<<": "<<d[i]<<"\n";
}
```

$\clearpage$

## Lowest Common Ancestor (LCA)

Encuentra el ancestro común más bajo entre dos nodos a y b usando binary lifting.

```cpp
int LCA(Tree &t,int a,int b)
{
  auto is_ancestor=[&](int u,int v)
  {
    return t.tin[u]<=t.tin[v] && t.tout[u]>=t.tout[v];
  };
  if(is_ancestor(a,b)) return a;
  if(is_ancestor(b,a)) return b;

  for(int j=t.LOG-1;j>=0;j--)
    if(!is_ancestor(t.up[a][j],b))
      a=t.up[a][j];
  return t.parent[a];
}

// Uso:
int main()
{
  vvi g={{1,2},{0,3,4},{0},{1},{1}};
  Tree t(g);
  cout<<"LCA(3,4): "<<LCA(t,3,4)<<"\n";
}
```

## Balanced Factor

Calcula el factor de balance (altura izquierda - altura derecha) para verificar si el árbol está equilibrado.
(No usa rotaciones, solo cálculo conceptual.)

```cpp
int balance_factor(Tree &t,int u)
{
  function<int(int,int)> height=[&](int x,int p)
  {
    int h=0;
    for(int v:t.g[x]) if(v!=p)
      h=max(h,1+height(v,x));
    return h;
  };
  vi hs;
  for(int v:t.g[u]) hs.push_back(height(v,u));
  if(hs.empty()) return 0;
  sort(all(hs),greater<int>());
  int l=hs[0], r=hs.size()>1?hs[1]:0;
  return l-r;
}

// Uso:
int main()
{
  vvi g={{1,2},{0},{0}};
  Tree t(g);
  cout<<"Balance(0): "<<balance_factor(t,0)<<"\n";
}
```
