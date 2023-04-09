#include <bits/stdc++.h>
#define ff first
#define ss second
#define mp make_pair
#define fast_io do { ios::sync_with_stdio(false), cin.tie(0); } while(0)
#ifdef TDEBUG
#define debug(...) dout(#__VA_ARGS__, __VA_ARGS__)
#define cdeb cout
#define dfast_io do {} while(0)
#else
#define debug(...) do {} while(0)
struct dostream {} cdeb;
#define dfast_io fast_io
template<typename T>
dostream& operator<<(dostream& out, T&& t) { return out; }
#endif

template<typename T>
void dout(std::string const& name, T arg) { std::cerr << name << " = " << arg << std::endl; }
template<typename T1, typename... T2>
void dout(std::string const& names, T1 arg, T2... args) {
    std::cerr << names.substr(0, names.find(',')) << " = " << arg << " | ";
    dout(names.substr(names.find(',') + 2), args...);
}

using namespace std;
typedef long long ll;
typedef pair<int, int> pii;

template<typename A, typename B>
ostream& operator<<(ostream& out, pair<A, B> const& p) { out << "(" << p.ff << ", " << p.ss << ")"; return out; }
template<typename T>
ostream& operator<<(ostream& out, vector<T> const& v) { for (auto const& e : v) out << e << " "; return out; }
template<typename T>
ostream& operator<<(ostream& out, pair<T*,int> p) { for (;p.ss--;p.ff++) out << *p.ff << " "; return out; }

const int maxn = 2e5 + 10;
const int mod = 1e9 + 7;

int main() {
    dfast_io;

    return 0;
}
